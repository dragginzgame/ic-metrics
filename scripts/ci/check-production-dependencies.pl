#!/usr/bin/env perl
use strict;
use warnings;
use Cwd qw(getcwd);
use FindBin qw($Bin);
use JSON::PP qw(decode_json);

# Metrics owns this two-library policy. Cargo owns target/feature resolution;
# this check never installs tools, builds artifacts or changes the locked graph.
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

my $metadata = decode_json(observe(qw(cargo metadata --no-deps --locked --format-version 1)));
ref($metadata) eq 'HASH' && ($metadata->{version} // 0) == 1
    && ref($metadata->{workspace_members}) eq 'ARRAY'
    && ref($metadata->{packages}) eq 'ARRAY'
    or die "invalid Cargo workspace metadata\n";
my %members = map { $_ => 1 } @{$metadata->{workspace_members}};
my %packages;
for my $package (@{$metadata->{packages}}) {
    next unless $members{$package->{id}};
    my $name = $package->{name};
    ($name eq 'ic-metrics' || $name eq 'ic-metrics-stable') && !$packages{$name}++
        or die "unclassified production workspace package: $name\n";
    ref($package->{dependencies}) eq 'ARRAY' or die "missing declared dependencies\n";
    for my $dependency (@{$package->{dependencies}}) {
        # Development dependencies must not bypass the governed Storage facade.
        $dependency->{name} ne 'ic-stable-structures'
            or die "$name directly depends on the stable substrate\n";
    }
}
keys(%members) == 2 && keys(%packages) == 2
    or die "expected both Metrics production libraries\n";
my @hosts = observe(qw(rustc -vV)) =~ /^host: ([A-Za-z0-9_-]+)$/mg;
@hosts == 1 or die "cannot identify the prepared compiler host\n";
my %targets = map { $_ => 1 } ($hosts[0], 'wasm32-unknown-unknown');
for my $target (sort keys %targets) {
    for my $root (sort keys %packages) {
        my @policy = $root eq 'ic-metrics'
            ? ('--forbid-pattern', '^(?!ic-metrics$)', '--require', 'ic-metrics=1')
            : ('--forbid-pattern', '^ic-(?:build|host|testkit)(?:-|$)|^pocket-ic$',
               '--forbid-feature', 'ic-memory/test-support',
               '--require', 'ic-memory=1', '--require', 'ic-storage=1',
               '--require', 'ic-stable-structures=1');
        print observe('perl', "$Bin/check-cargo-graph.pl", '--consumer', getcwd(),
            '--package', $root, '--target', $target, @policy);
    }
}
