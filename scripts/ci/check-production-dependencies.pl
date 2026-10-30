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
my %transport_policy = (
    serde => { target => undef, features => ['derive'], optional => 0 },
    'ic-wire' => { target => 'cfg(not(target_family = "wasm"))', features => ['typescript'], optional => 1 },
);
my %packages;
my %observed_members;
for my $package (@{$metadata->{packages}}) {
    next unless $members{$package->{id}};
    my $name = $package->{name};
    exists($owners{$name}) && !$packages{$name}++ && !$observed_members{$package->{id}}++
        or die "unclassified production workspace package: $name\n";
    ref($package->{dependencies}) eq 'ARRAY' or die "missing declared dependencies\n";
    my $features = $package->{features};
    ref($features) eq 'HASH' or die "missing declared features\n";
    my @defaults = $owners{$name} eq 'measurement' ? ('native-wire') : ();
    join("\0", @{$features->{default} // []}) eq join("\0", @defaults)
        or die "$name has unapproved default features\n";
    if ($owners{$name} eq 'measurement') {
        ref($features->{'native-wire'}) eq 'ARRAY'
            && join("\0", @{$features->{'native-wire'}}) eq 'dep:ic-wire'
            or die "native-wire must select only the optional Wire dependency\n";
    }
    my %transport;
    for my $dependency (@{$package->{dependencies}}) {
        # Metadata includes inactive optional and target-specific declarations.
        if (($dependency->{kind} // 'normal') ne 'dev') {
            my $dep = $dependency->{name};
            $owners{$name} eq 'measurement'
                or die "$name declares a production dependency: $dep\n";
            ($dep eq 'serde' || $dep eq 'ic-wire')
                or die "$name declares a production dependency: $dep\n";
            my $policy = $transport_policy{$dep};
            !!$dependency->{optional} == $policy->{optional} && !$dependency->{uses_default_features}
                && ($dependency->{kind} // 'normal') eq 'normal'
                or die "transport dependency has unapproved optionality or defaults\n";
            !$transport{$dep}++ or die "duplicate transport declaration\n";
            ($dependency->{target} // '') eq ($policy->{target} // '')
                or die "$dep has an unapproved target placement\n";
            ref($dependency->{features}) eq 'ARRAY'
                && join("\0", sort @{$dependency->{features}}) eq join("\0", @{$policy->{features}})
                or die "$dep has unapproved transport features\n";
        }
        # Development dependencies must not bypass the governed Storage facade.
        $dependency->{name} ne 'ic-stable-structures'
            or die "$name directly depends on the stable substrate\n";
    }
    # Local switches may compose one another, never widen dependency features.
    for my $feature (keys %$features) {
        my $edges = $features->{$feature};
        ref($edges) eq 'ARRAY' or die "invalid declared features\n";
        for my $edge (@$edges) {
            next if $owners{$name} eq 'measurement' && $feature eq 'native-wire' && $edge eq 'dep:ic-wire';
            defined($edge) && !ref($edge) && exists($features->{$edge})
                or die "$name forwards dependency features\n";
        }
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
