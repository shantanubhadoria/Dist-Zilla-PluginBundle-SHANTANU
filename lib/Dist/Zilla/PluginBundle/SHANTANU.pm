use strict;
use warnings;

package Dist::Zilla::PluginBundle::SHANTANU;
# PODNAME: Dist::Zilla::PluginBundle::SHANTANU

# VERSION

# Dependencies
use 5.010;
use autodie 2.00;
use Moose 0.99;
use Moose::Autobox;
use namespace::autoclean 0.09;

use Dist::Zilla 4.3; 

use Dist::Zilla::PluginBundle::Git 2.009;

use Dist::Zilla::Plugin::Git::NextVersion;
use Dist::Zilla::Plugin::AutoMetaResources;

use Dist::Zilla::Plugin::ContributorsFromGit;

use Dist::Zilla::Plugin::PruneCruft;
use Dist::Zilla::Plugin::ManifestSkip;

use Dist::Zilla::Plugin::OurPkgVersion;
use Dist::Zilla::Plugin::InsertCopyright;

use Dist::Zilla::Plugin::TaskWeaver;
use Dist::Zilla::Plugin::PodWeaver;

use Dist::Zilla::Plugin::ReadmeAnyFromPod;

use Dist::Zilla::Plugin::License;

use Dist::Zilla::Plugin::Test::Compile;
use Dist::Zilla::Plugin::Test::MinimumVersion;
use Dist::Zilla::Plugin::Test::ReportPrereqs;


use Dist::Zilla::Plugin::Test::PodSpelling;
use Test::Portability::Files 0.06 (); # buggy before that
use Dist::Zilla::Plugin::Test::Perl::Critic;
use Dist::Zilla::Plugin::Test::Kwalitee::Extra;
use Dist::Zilla::Plugin::MetaTests;
use Dist::Zilla::Plugin::PodSyntaxTests;
use Dist::Zilla::Plugin::PodCoverageTests;
use Dist::Zilla::Plugin::Test::Portability;
use Dist::Zilla::Plugin::Test::Version;

use Dist::Zilla::Plugin::MinimumPerl;
use Dist::Zilla::Plugin::MetaNoIndex;
use Dist::Zilla::Plugin::MetaProvides::Package;
use Dist::Zilla::Plugin::MetaYAML;
use Dist::Zilla::Plugin::MetaJSON;

use Dist::Zilla::Plugin::PerlTidy;
use Dist::Zilla::Plugin::MakeMaker::Awesome;
use Dist::Zilla::Plugin::CopyFilesFromBuild;
use Dist::Zilla::Plugin::CheckMetaResources;
use Dist::Zilla::Plugin::CheckPrereqsIndexed;
use Dist::Zilla::Plugin::ChangelogFromGit::CPAN::Changes;
use Dist::Zilla::Plugin::ChangelogFromGit::Debian;
use Dist::Zilla::Plugin::Control::Debian;
use Dist::Zilla::Plugin::CheckChangesHasContent;
use Dist::Zilla::Plugin::CheckExtraTests;


with 'Dist::Zilla::Role::PluginBundle::Easy';
with 'Dist::Zilla::Role::PluginBundle::Config::Slicer';

#Gather Stopwords that may skip spelling checks in pod testing
sub mvp_multivalue_args { qw/stopwords exclude_filename exclude_match/ }

=attr no_git

makemaker attribute By default uses [MakeMaker::Awesome] This can be overriden by defining this attribute

=cut

has makemaker => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { 
        exists $_[0]->payload->{makemaker} 
        ? $_[0]->payload->{makemaker} 
        : "MakeMaker::Awesome";
    },
);

=attr skip_makemaker 

Skip Default Makemaker option to add your own plugin for generating makefile

=cut

has skip_makemaker => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{skip_makemaker} },
);

=attr no_git

no_git attribute

=cut

has no_git => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{no_git} },
);

=attr version_regexp 

version_regexp attribute

=cut

has version_regexp => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{version_regexp}
          ? $_[0]->payload->{version_regexp}
          : '^release-(.+)$',
          ;
    },
);

has is_task => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{is_task} },
);

has weaver_config => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->payload->{weaver_config} || '@SHANTANU' },
);

has no_spellcheck => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{no_spellcheck}
          ? $_[0]->payload->{no_spellcheck}
          : 0;
    },
);

=attr exclude_filename

list of filenames to exclude e.g.
    exclude_filename=dist.ini
    exclude_filename=META.json
    exclude_filename=META.yml

=cut

has exclude_filename => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{exclude_filename} 
        ? $_[0]->payload->{exclude_filename} 
        : [qw/dist.ini Changes README.pod META.json META.yml/];
    },
);

=attr exclude_match

list of regex paths to exclude e.g.
    exclude_match=^inc\/.*

=cut

has exclude_match => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{exclude_match} 
        ? $_[0]->payload->{exclude_match} 
        : [];
    },
);

=attr stopwords

Stopwords to exclude for spell checks in pod

=cut

has stopwords => (
    is      => 'ro',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{stopwords} ? $_[0]->payload->{stopwords} : [];
    },
);

has no_critic => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{no_critic} ? $_[0]->payload->{no_critic} : 0;
    },
);

has no_coverage => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{no_coverage}
          ? $_[0]->payload->{no_coverage}
          : 0;
    },
);

has auto_prereq => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{auto_prereq} ? $_[0]->payload->{auto_prereq} : 1;
    },
);

has fake_release => (
    is      => 'ro',
    isa     => 'Bool',
    lazy    => 1,
    default => sub { $_[0]->payload->{fake_release} },
);

has tag_format => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{tag_format} ? $_[0]->payload->{tag_format} : 'release-%v',;
    },
);

has git_remote => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        exists $_[0]->payload->{git_remote} ? $_[0]->payload->{git_remote} : 'origin',;
    },
);

sub configure {
    my $self = shift;

    my @push_to = ('origin');
    push @push_to, $self->git_remote if $self->git_remote ne 'origin';

    $self->add_plugins(
        # version number use Autoversion Plugin if no_git is set else use Git::NextVersion based on version_regexp or default version regex
        (
            $self->no_git
            ? 'AutoVersion'
            : [ 'Git::NextVersion' => { version_regexp => $self->version_regexp } ]
        ),
        'PerlTidy',

        # contributors
        (
            $self->no_git
            ? ()
            : 'ContributorsFromGit'
        ),

        'PruneCruft',                                                               # core
        'ManifestSkip',                                                             # core

        # file munging
        'OurPkgVersion',
        'InsertCopyright',

        (
            $self->is_task
            ? 'TaskWeaver'
            : [ 'PodWeaver' => { config_plugin => $self->weaver_config } ]
        ),

        # generated distribution files
        'ReadmeAnyFromPod', # in build dir
        [
            ReadmeAnyFromPod => ReadmeInRoot => { # also generate in root for github, etc.
                type     => 'pod',
                filename => 'README.pod',
                location => 'root',
            }
        ],

        'License',                              # core

        # generated t/ tests
        [ 'Test::Compile' => { fake_home => 1 } ],
        [ 'Test::MinimumVersion' => { max_target_perl => '5.010' } ],
        'Test::ReportPrereqs',

        # gather and prune
        (
            $self->no_git
            ? [
                'GatherDir' =>
                  { 
                      exclude_filename => $self->exclude_filename
                      , exclude_match    => $self->exclude_match 
                  },
              ]    # core
            : [
                'Git::GatherDir' =>
                  { 
                      exclude_filename => $self->exclude_filename 
                      , exclude_match    => $self->exclude_match 
                  },
            ]
        ),

        #Automatically put Resources which need not be specified manually
        [
            AutoMetaResources => {
                'repository.github' => 'user:shantanubhadoria',
                'bugtracker.github' => 'user:shantanubhadoria',
                'bugtracker.rt'     => 0,
                'homepage'          => 'https://metacpan.org/release/%{dist}',
            }
        ],

        # generated xt/ tests
        (
            $self->no_spellcheck
            ? ()
            : [ 'Test::PodSpelling' => { stopwords => $self->stopwords } ]
        ),
        (
            $self->no_critic
            ? ()
            : ('Test::Perl::Critic')
        ),
        [
            'Test::Kwalitee::Extra' =>{
                has_corpus => 0,
            },
        ],
        'MetaTests',      # core
        'PodSyntaxTests', # core
        (
            $self->no_coverage
            ? ()
            : ('PodCoverageTests') # core
        ),
        [ 'Test::Portability' => { options => "test_one_dot = 0" } ],
        'Test::Version',

        # metadata
        'MinimumPerl',
        (
            $self->auto_prereq
            ? [ 'AutoPrereqs' => { skip => "^t::lib" } ]
            : ()
        ),
        [
            MetaNoIndex => {
                directory => [qw/t xt examples corpus inc/],
                'package' => [qw/DB/]
            }
        ],
        [ 'MetaProvides::Package' => { meta_noindex => 1 } ], # AFTER MetaNoIndex

        'MetaYAML',                                           # core : Helps avoid kwalitee croaks and supports older systems
        'MetaJSON',                                           # core
        [
            'ChangelogFromGit::CPAN::Changes' => {
                tag_regexp             => '^release-(\d+\.\d+)$',
                parse_version_from_tag => 1,
                transform_version_tag  => 1,
                file_name              => 'Changes',
            }
        ],
        [
            'ChangelogFromGit::Debian' => {
                tag_regexp             => '^release-(\d+\.\d+)$',
                parse_version_from_tag => 1,
                file_name              => 'debian/changelog',
                maintainer_name        => 'Shantanu Bhadoria',
                maintainer_email       => 'shantanu@cpan.org',
            }
        ],
        [
            'Control::Debian' => {
                file_name              => 'debian/control',
                maintainer_name        => 'Shantanu Bhadoria',
                maintainer_email       => 'shantanu@cpan.org',
            }
        ],

        # build system
        'ExecDir',                                            # core
        'ShareDir',                                           # core
        (
            $self->skip_makemaker
            ? ()
            : $self->makemaker
        ), # core

        # copy files from build back to root for inclusion in VCS
        [
            CopyFilesFromBuild => {
                copy => qw[META.yml Changes],
            }
        ],

        # manifest -- must come after all generated files
        'Manifest',                                           # core

        # before release
        (
            $self->no_git
            ? ()
            : [ 'Git::Check' => { 
                    allow_dirty => [qw/dist.ini Changes README.pod META.yml/] 
            } ]
        ),
        'CheckMetaResources',
        'CheckPrereqsIndexed',
        'CheckExtraTests',
        'TestRelease',                                        # core
        'ConfirmRelease',                                     # core

        # release
        ( $self->fake_release ? 'FakeRelease' : 'UploadToCPAN' ), # core

        # after release
        # Note -- NextRelease is here to get the ordering right with
        # git actions.  It is *also* a file munger that acts earlier

        # commit dirty Changes, dist.ini, README.pod, META.json, META.yml
        (
            $self->no_git
            ? ()
            : (
                [
                    'Git::Commit' => 'Commit_Dirty_Files' =>
                      { allow_dirty => [qw/dist.ini Changes README.pod META.json META.yml/] }
                ],
                [ 'Git::Tag' => { tag_format => $self->tag_format } ],
            )
        ),

        # bumps Changes
        [
            'NextRelease' => {
                format => '%n%v%n%n%t- %{yyyy-MM-dd HH:mm:ss VVVV}d%n',
            },
        ], # core (also munges files)

        (
            $self->no_git
            ? ()
            : (
                [ 'Git::Commit' => 'Commit_Changes' => { commit_msg => "Bump Changes" } ],

                [ 'Git::Push' => { push_to => \@push_to } ],
            )
        ),
    );
}
__PACKAGE__->meta->make_immutable;

1;

# ABSTRACT: Dist Zilla Plugin Bundle the way I like to use it

# COPYRIGHT

__END__


=for stopwords
autoprereq dagolden fakerelease pluginbundle podweaver
taskweaver uploadtocpan dist ini

=for Pod::Coverage configure mvp_multivalue_args

=begin wikidoc

= SYNOPSIS

  # in dist.ini
    [@SHANTANU]


= DESCRIPTION

This is a [Dist::Zilla] PluginBundle. The way I use it. While this bundle is 
customized to my needs, others might be better of forking this repository and 
modifying it to their own needs or using the more mature Plugin bundles that 
this is derived from like the one by David Golden. 

= USAGE

To use this PluginBundle, just add it to your dist.ini.  You can provide
the following options:

* {is_task} -- this indicates whether TaskWeaver or PodWeaver should be used.
Default is 0.
* {auto_prereq} -- this indicates whether AutoPrereq should be used or not.
Default is 1.
* {tag_format} -- given to {Git::Tag}.  Default is 'release-%v' to be more
robust than just the version number when parsing versions for
{Git::NextVersion}
* {version_regexp} -- given to {Git::NextVersion}.  Default
is '^release-(.+)$'
* {fake_release} -- swaps FakeRelease for UploadToCPAN. Mostly useful for
testing a dist.ini without risking a real release.
* {weaver_config} -- specifies a Pod::Weaver bundle.  Defaults to @SHANTANU.
* {stopwords} -- add stopword for Test::PodSpelling (can be repeated)
* {no_git} -- bypass all git-dependent plugins
* {no_critic} -- omit Test::Perl::Critic tests
* {no_spellcheck} -- omit Test::PodSpelling tests
* {no_coverage} -- omit Pod Coverage tests

When running without git, C<GatherDir> is used instead of C<Git::GatherDir>,
C<AutoVersion> is used instead of C<Git::NextVersion>, and all git check and
commit operations are disabled.

This PluginBundle now supports ConfigSlicer, so you can pass in options to the
plugins used like this:

  [@SHANTANU]
  ExecDir.dir = scripts ; overrides ExecDir

= COMMON PATTERNS

== use github instead of RT

  [@SHANTANU]
  :version = 0.32
  AutoMetaResources.bugtracker.github = user:shantanu
  AutoMetaResources.bugtracker.rt = 0

= SEE ALSO

* [Dist::Zilla]
* [Dist::Zilla::Plugin::PodWeaver]
* [Dist::Zilla::Plugin::TaskWeaver]

=end wikidoc

=cut
