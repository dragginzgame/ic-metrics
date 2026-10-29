#!/usr/bin/env perl
use strict;
use warnings;
use Cwd qw(getcwd);
use JSON::PP qw(decode_json);

# Metrics owns declaration admission, including the explicit opt-in transport allowlist.
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
my %packages;
for my $package (@{$metadata->{packages}}) {
    next unless $members{$package->{id}};
    my $name = $package->{name};
    ($name eq 'ic-metrics') && !$packages{$name}++
        or die "unclassified production workspace package: $name\n";
    ref($package->{dependencies}) eq 'ARRAY' or die "missing declared dependencies\n";
    my $features = $package->{features} // {};
    !@{$features->{default} // []} or die "default arithmetic enables features\n";
    for my $feature (keys %$features) {
        next if $feature eq 'wire';
        for my $activation (@{$features->{$feature}}) {
            $activation !~ /^(?:wire|dep:serde|dep:ic-wire|serde[?]?\/.*|ic-wire[?]?\/.*)$/
                or die "transport activation outside wire feature\n";
        }
    }
    for my $dependency (@{$package->{dependencies}}) {
        # Metadata includes inactive optional and target-specific declarations.
        if (($dependency->{kind} // 'normal') ne 'dev') {
            my $dep = $dependency->{name};
            ($dep eq 'serde' || $dep eq 'ic-wire')
                or die "$name declares a production dependency: $dep\n";
            $dependency->{optional} && !$dependency->{uses_default_features}
                && ($dependency->{kind} // 'normal') eq 'normal'
                or die "transport dependency must be optional without defaults\n";
            my @wire = sort @{$features->{wire} // []};
            join(',', @wire) eq 'dep:ic-wire,dep:serde'
                or die "transport dependencies require explicit wire feature\n";
        }
        # Development dependencies must not bypass the governed Storage facade.
        $dependency->{name} ne 'ic-stable-structures'
            or die "$name directly depends on the stable substrate\n";
    }
}
keys(%members) == 1 && keys(%packages) == 1
    or die "expected only the Metrics arithmetic library\n";
print "Default arithmetic and optional transport declarations admitted.\n";
