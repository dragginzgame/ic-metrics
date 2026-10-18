#!/usr/bin/env perl
use strict;
use warnings;
use Cwd qw(getcwd);
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
        my $tree = observe('cargo', 'tree', '--locked', '--color', 'never',
            '-p', $root, '--target', $target, '--edges', 'normal,build',
            '--prefix', 'none', '--format', '{p}|{f}');
        my @rows = split /\n/, $tree;
        @rows or die "empty production graph for $root ($target)\n";
        my $index = 0;
        for my $row (@rows) {
            # The final delimiter separates Cargo's explicitly requested feature
            # field; a checkout path may itself contain spaces or vertical bars.
            $row =~ /\A([A-Za-z0-9_-]+) v\S+[^\n]*\|([A-Za-z0-9_,+.-]*)(?: \(\*\))?\z/
                or die "malformed Cargo tree row for $root ($target)\n";
            my ($name, $features) = ($1, $2);
            if ($index++ == 0) {
                $name eq $root or die "production graph root differs: $root ($target)\n";
            } elsif ($root eq 'ic-metrics') {
                die "ic-metrics has a production dependency: $name ($target)\n";
            }
            $name !~ /\Aic-(?:host|testkit)(?:-|\z)/ && $name ne 'pocket-ic'
                or die "$root reaches tooling package $name ($target)\n";
            my %enabled = map { $_ => 1 } split /,/, $features;
            !($name eq 'ic-memory' && $enabled{'test-support'})
                or die "$root enables Memory test-support ($target)\n";
        }
        print "[OK] $root production graph ($target)\n";
    }
}
