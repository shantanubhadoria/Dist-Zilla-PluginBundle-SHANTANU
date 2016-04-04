use strict;
use warnings;

package Badge::Depot::Plugin::Shantanutravis;
# VERSION

# Dependencies
use Moose;
use namespace::autoclean;
use Types::Standard qw/Str HashRef/;
use Path::Tiny;
use JSON::MaybeXS 'decode_json';
with 'Badge::Depot';

# ABSTRACT: Shantanu Bhadoria's Travis plugin for Badge::Depot based off Badge::Depot::Plugin::Travis

=attr user

=cut

has user => (
    is => 'ro',
    isa => Str,
    lazy => 1,
    default => sub {
        my $self = shift;
        if($self->has_meta) {
            return $self->_meta->{'username'} if exists $self->_meta->{'username'};
        }
    },
);

=attr repo

=cut

has repo => (
    is => 'ro',
    isa => Str,
    lazy => 1,
    default => sub {
        my $self = shift;
        if($self->zilla) {
            return 'perl-' . $self->zilla->name;
        }
    },
);

=attr branch

=cut

has branch => (
    is => 'ro',
    isa => Str,
    default => 'build/master',
);

has _meta => (
    is => 'ro',
    isa => HashRef,
    predicate => 'has_meta',
    builder => '_build_meta',
);

sub _build_meta {
    my $self = shift;

    if( $self->zilla ) {
        return {
            repo    => 'perl-' . $self->zilla->name,
            version => $self->zilla->version,
        }
    }

    return {} if !path('META.json')->exists;

    my $json = path('META.json')->slurp_utf8;
    my $data = decode_json($json);

    return {} if !exists $data->{'resources'}{'repository'}{'web'};

    my $repository = $data->{'resources'}{'repository'}{'web'};
    return {} if $repository !~ m{^https://(?:www\.)?github\.com/([^/]+)/(.*)(?:\.git)?$};

    return {
        username => $1,
        repo => $2,
    };
}

=method BUILD

=cut

sub BUILD {
    my $self = shift;
    $self->link_url(sprintf 'https://travis-ci.org/%s/%s', $self->user, $self->repo);
    $self->image_url(sprintf 'https://api.travis-ci.org/%s/%s.svg?branch=%s', $self->user, $self->repo, $self->branch);
    $self->image_alt('Travis status');
}

1;
