#!/usr/bin/env perl
use strict;
use warnings;
use JSON::PP qw(decode_json);

# Resolved normal/build closures complement declaration admission. Development
# codec fixtures must not make Wire appear to be a production dependency.
@ARGV == 0 or die "usage: check-metrics-profiles.pl\n";
$ENV{RUSTUP_AUTO_INSTALL} = '0';

sub observe {
    my (@command) = @_;
    open my $child, '-|', @command or die "cannot start $command[0]: $!\n";
    local $/;
    my $output = <$child> // '';
    close $child or die "failed observation: @command\n";
    return $output;
}

my ($host) = observe(qw(rustc -vV)) =~ /^host: (\S+)$/m;
defined($host) or die "missing compiler host triple\n";
my @profiles = (
    ['native-minimal', $host, 0, '--no-default-features'],
    ['native-recording', $host, 0, '--no-default-features', '--features', 'ic-metrics/recording'],
    ['native-default', $host, 1],
    ['wasm-all-features', 'wasm32-unknown-unknown', 0, '--all-features'],
);

for my $profile (@profiles) {
    my ($name, $target, $wire_expected, @features) = @$profile;
    my $metadata = decode_json(observe(
        qw(cargo metadata --locked --offline --format-version 1 --filter-platform),
        $target, @features,
    ));
    ref($metadata->{resolve}{nodes}) eq 'ARRAY' or die "$name: missing resolved graph\n";
    my %packages = map { $_->{id} => $_ } @{$metadata->{packages}};
    my %nodes = map { $_->{id} => $_ } @{$metadata->{resolve}{nodes}};
    my %roots = map { $packages{$_}{name} => $_ } @{$metadata->{workspace_members}};
    for my $owner ('ic-metrics', 'ic-logging') {
        defined($roots{$owner}) or die "$name: missing $owner\n";
        my @pending = ($roots{$owner});
        my %seen;
        while (@pending) {
            my $id = pop @pending;
            next if $seen{$id}++;
            my $node = $nodes{$id} // die "$name: missing resolved node\n";
            for my $dependency (@{$node->{deps}}) {
                next unless grep { ($_->{kind} // 'normal') ne 'dev' }
                    @{$dependency->{dep_kinds}};
                push @pending, $dependency->{pkg};
            }
        }
        my @wire = grep { $packages{$_}{name} eq 'ic-wire' } keys %seen;
        my @derive = grep { $packages{$_}{name} eq 'ic-wire-derive' } keys %seen;
        !grep { $packages{$_}{name} =~ /\A(?:ic-platform|ic-platform-types|ic-wire-endpoint)\z/ } keys %seen
            or die "$name: $owner selects a Platform or endpoint integration\n";
        if ($owner eq 'ic-logging') {
            keys(%seen) == 1 or die "$name: Logging has production dependencies\n";
        } else {
            @wire == $wire_expected && @derive == $wire_expected
                or die "$name: unexpected Wire/derive closure\n";
            grep { $packages{$_}{name} eq 'serde' } keys %seen
                or die "$name: missing standard Serde transport\n";
        }
    }
    print "$name: resolved Metrics/Logging production graphs admitted\n";
}
