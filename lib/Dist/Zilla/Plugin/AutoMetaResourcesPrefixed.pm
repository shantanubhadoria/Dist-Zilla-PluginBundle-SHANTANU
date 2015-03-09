use strict;
use warnings;

package Dist::Zilla::Plugin::AutoMetaResourcesPrefixed;
#VERSION

use Moose;
extends 'Dist::Zilla::Plugin::AutoMetaResources';

sub _build__repository_map {
    # based on Dist::Zilla::PluginBundle::FLORA
    return {
        github => {
            url => 'git://github.com/%{user}/perl-%{lcdist}.git',
            web => 'https://github.com/%{user}/perl-%{lcdist}',
            type => 'git',
        },
        gitmo => {
            url => 'git://git.moose.perl.org/%{dist}.git',
            web => 'http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=gitmo/%{dist}.git;a=summary',
            type => 'git',
        },
        catsvn => {
            url => 'http://dev.catalyst.perl.org/repos/Catalyst/%{dist}/',
            web => 'http://dev.catalystframework.org/svnweb/Catalyst/browse/%{dist}',
            type => 'svn',
        },
        (map {
            ($_ => {
                url     => "git://git.shadowcat.co.uk/$_/%{dist}.git",
                web => "http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=$_/%{dist}.git;a=summary",
                type    => 'git',
            })
        } qw(catagits p5sagit dbsrgits)),
    };
}

sub _build__bugtracker_map {
    return {
        rt => {
            web => 'https://rt.cpan.org/Public/Dist/Display.html?Name=%{dist}',
            mailto => 'bug-%{dist}@rt.cpan.org',
        },
        github => {
            web => 'https://github.com/%{user}/perl-%{lcdist}/issues',
        }
    }
}

1;
