#!/usr/bin/env perl
use strict;
use warnings;
use Cwd qw(getcwd);
use JSON::PP qw(decode_json);

# Observability owns per-package declaration admission and transport boundaries.
# This check never installs tools, builds artifacts or changes the locked graph.
if (@ARGV) {
    @ARGV == 2 && shift(@ARGV) eq '--consumer'
        or die "usage: check-production-dependencies.pl [--consumer ROOT]\n";
    my $directory = shift @ARGV;
    $directory !~ /[\r\n]/ or die "consumer path contains CR/LF\n";
    chdir $directory or die "cannot enter consumer: $!\n";
}
getcwd() !~ /[\r\n]/ or die "resolved consumer path contains CR/LF\n";
$ENV{RUSTUP_AUTO_INSTALL} = '0';

sub observe {
    my (@command) = @_;
    open my $child, '-|', @command or die "cannot start $command[0]: $!\n";
    local $/;
    my $bytes = <$child> // '';
    close $child or die "failed observation: @command\n";
    return $bytes;
}

my $bytes = observe(qw(cargo metadata --no-deps --locked --offline --format-version 1));
my $metadata = eval { decode_json($bytes) };
$@ and die "invalid Cargo workspace metadata\n";
ref($metadata) eq 'HASH' && ($metadata->{version} // 0) == 1
    && ref($metadata->{workspace_members}) eq 'ARRAY'
    && ref($metadata->{packages}) eq 'ARRAY'
    or die "invalid Cargo workspace metadata\n";
my %members = map { $_ => 1 } @{$metadata->{workspace_members}};
my %owners = ('ic-metrics' => 'measurement', 'ic-logging' => 'logging');
my %packages;
my %observed_members;
for my $package (@{$metadata->{packages}}) {
    next unless $members{$package->{id}};
    my $name = $package->{name};
    exists($owners{$name}) && !$packages{$name}++ && !$observed_members{$package->{id}}++
        or die "unclassified production workspace package: $name\n";
    ref($package->{dependencies}) eq 'ARRAY' or die "missing declared dependencies\n";
    my $features = $package->{features} // {};
    !@{$features->{default} // []} or die "$name enables default features\n";
    my %transport;
    for my $dependency (@{$package->{dependencies}}) {
        # Metadata includes inactive optional and target-specific declarations.
        if (($dependency->{kind} // 'normal') ne 'dev') {
            my $dep = $dependency->{name};
            $owners{$name} eq 'measurement'
                or die "$name declares a production dependency: $dep\n";
            ($dep eq 'serde' || $dep eq 'ic-wire')
                or die "$name declares a production dependency: $dep\n";
            !$dependency->{optional} && !$dependency->{uses_default_features}
                && ($dependency->{kind} // 'normal') eq 'normal'
                or die "transport dependency must be required without defaults\n";
            !$transport{$dep}++ or die "duplicate transport declaration\n";
        }
        # Development dependencies must not bypass the governed Storage facade.
        $dependency->{name} ne 'ic-stable-structures'
            or die "$name directly depends on the stable substrate\n";
    }
    if ($owners{$name} eq 'measurement') {
        $transport{'serde'} && $transport{'ic-wire'}
            or die "missing standard transport dependency\n";
    }
}
for my $name (keys %owners) {
    $packages{$name} or die "missing registered workspace package: $name\n";
}
for my $member (keys %members) {
    $observed_members{$member} or die "missing workspace member metadata\n";
}
print "Metrics transport and independent Logging declarations admitted.\n";
