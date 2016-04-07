# NAME

Dist::Zilla::PluginBundle::SHANTANU - Dist Zilla Plugin Bundle the way I like to use it

<div>
    <p>
    <img src="https://img.shields.io/badge/perl-5.10+-brightgreen.svg" alt="Requires Perl 5.10+" />
    <a href="https://travis-ci.org/shantanubhadoria/perl-Dist-Zilla-PluginBundle-SHANTANU"><img src="https://api.travis-ci.org/shantanubhadoria/perl-Dist-Zilla-PluginBundle-SHANTANU.svg?branch=build/master" alt="Travis status" /></a>
    <a href="http://matrix.cpantesters.org/?dist=Dist-Zilla-PluginBundle-SHANTANU%200.41"><img src="https://badgedepot.code301.com/badge/cpantesters/Dist-Zilla-PluginBundle-SHANTANU/0.41" alt="CPAN Testers result" /></a>
    <a href="http://cpants.cpanauthors.org/dist/Dist-Zilla-PluginBundle-SHANTANU-0.41"><img src="https://badgedepot.code301.com/badge/kwalitee/Dist-Zilla-PluginBundle-SHANTANU/0.41" alt="Distribution kwalitee" /></a>
    <a href="https://gratipay.com/shantanubhadoria"><img src="https://img.shields.io/gratipay/shantanubhadoria.svg" alt="Gratipay" /></a>
    </p>
</div>

# VERSION

version 0.41

# SYNOPSIS

    # in dist.ini
      [@SHANTANU]

# DESCRIPTION

This is a [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) PluginBundle. The way I use it. While this bundle is
customized to my needs, others might be better of forking this repository and
modifying it to their own needs or using the more mature Plugin bundles that
this is derived from like the one by David Golden.

# ATTRIBUTES

## makemaker

makemaker attribute By default uses \[MakeMaker::Awesome\] This can be overriden by defining this attribute

## skip\_makemaker

Skip Default Makemaker option to add your own plugin for generating makefile

## no\_git

no\_git attribute

## no\_commitbuild

no\_commitbuild attribute, do not create a build branch

## version\_regexp

version\_regexp attribute

## is\_task

Use Taskweaver in lieu of PodWeaver

## weaver\_config

PodWeaver config\_plugin attribute

## no\_spellcheck

Skip spelling checks

## exclude\_filename

list of filenames to exclude e.g.
    exclude\_filename=dist.ini
    exclude\_filename=META.json
    exclude\_filename=META.yml

## stopwords

Stopwords to exclude for spell checks in pod

## no\_critic

Skip Perl Critic Checks

## no\_coverage

Skip Pod Coverage tests

## test\_compile

Create compile tests.

## auto\_prereq

Automatically get prerequisites(default 1)

## fake\_release

## tag\_regexp

Regex for obtaining the version number from git tag

## compile\_for\_debian

generate debian specific files like control etc. Useful if you are using dh-make-perl for building .deb files from your package

## tag\_format

Git Tag format

## git\_remote

# USAGE

To use this PluginBundle, just add it to your dist.ini.  You can provide
the following options:

- `is_task` -- this indicates whether TaskWeaver or PodWeaver should be used.
Default is 0.
- `auto_prereq` -- this indicates whether AutoPrereq should be used or not.
Default is 1.
- `tag_format` -- given to `Git::Tag`.  Default is 'release-%v' to be more
robust than just the version number when parsing versions for
`Git::NextVersion`
- `version_regexp` -- given to `Git::NextVersion`.  Default
is '^release-(.+)$'
- `fake_release` -- swaps FakeRelease for UploadToCPAN. Mostly useful for
testing a dist.ini without risking a real release.
- `weaver_config` -- specifies a Pod::Weaver bundle.  Defaults to @SHANTANU.
- `stopwords` -- add stopword for Test::PodSpelling (can be repeated)
- `no_git` -- bypass all git-dependent plugins
- `no_critic` -- omit Test::Perl::Critic tests
- `no_spellcheck` -- omit Test::PodSpelling tests
- `no_coverage` -- omit Pod Coverage tests

When running without git, C<GatherDir> is used instead of C<Git::GatherDir>,
C<AutoVersion> is used instead of C<Git::NextVersion>, and all git check and
commit operations are disabled.

This PluginBundle now supports ConfigSlicer, so you can pass in options to the
plugins used like this:

    [@SHANTANU]
    ExecDir.dir = scripts ; overrides ExecDir

# COMMON PATTERNS

## use github instead of RT

    [@SHANTANU]
    :version = 0.32
    AutoMetaResourcesPrefixed.bugtracker.github = user:shantanu
    AutoMetaResourcesPrefixed.bugtracker.rt = 0

# SEE ALSO

- [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla)
- [Dist::Zilla::Plugin::PodWeaver](https://metacpan.org/pod/Dist::Zilla::Plugin::PodWeaver)
- [Dist::Zilla::Plugin::TaskWeaver](https://metacpan.org/pod/Dist::Zilla::Plugin::TaskWeaver)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through github at 
[https://github.com/shantanubhadoria/perl-dist-zilla-pluginbundle-shantanu/issues](https://github.com/shantanubhadoria/perl-dist-zilla-pluginbundle-shantanu/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/shantanubhadoria/perl-dist-zilla-pluginbundle-shantanu](https://github.com/shantanubhadoria/perl-dist-zilla-pluginbundle-shantanu)

    git clone git://github.com/shantanubhadoria/perl-dist-zilla-pluginbundle-shantanu.git

# AUTHOR

Shantanu Bhadoria <shantanu@cpan.org> [https://www.shantanubhadoria.com](https://www.shantanubhadoria.com)

# CONTRIBUTORS

- Karen Etheridge <ether@cpan.org>
- Shantanu Bhadoria &lt;shantanu att cpan dott org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Shantanu Bhadoria.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
