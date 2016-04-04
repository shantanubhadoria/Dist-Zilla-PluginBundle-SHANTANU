use strict;
use warnings;

package Pod::Weaver::PluginBundle::SHANTANU;
# VERSION

use Pod::Weaver 3.101638; 
use Pod::Weaver::Config::Assembler;

# Dependencies
use Pod::Weaver::Plugin::WikiDoc ();
use Pod::Elemental::Transformer::List 0.101620 ();
use Pod::Weaver::Section::Badges 0.0402        ();
use Badge::Depot::Plugin::Travis;
use Badge::Depot::Plugin::Gratipay;
use Pod::Weaver::Section::Support 1.001        ();
use Pod::Weaver::Section::Contributors 0.001   ();

sub _exp { Pod::Weaver::Config::Assembler->expand_package( $_[0] ) }

my $repo_intro = <<'END';
This is open source software.  The code repository is available for
public review and contribution under the terms of the license.
END

my $bugtracker_content = <<'END';
Please report any bugs or feature requests through github at 
{WEB}.
You will be notified automatically of any progress on your issue.
END

=method mvp_bundle_config

=cut

sub mvp_bundle_config {
    my @plugins;
    push @plugins, (
        [ '@SHANTANU/WikiDoc',  _exp('-WikiDoc'),  {} ],
        [ '@SHANTANU/CorePrep', _exp('@CorePrep'), {} ],
        [ '@SHANTANU/Name',     _exp('Name'),      {} ],
        [ '@SHANTANU/Version',  _exp('Version'),   {} ],
        [ '@SHANTANU/Prelude',     _exp('Region'),  { region_name => 'prelude' } ],
        [ '@SHANTANU/Synopsis',    _exp('Generic'), { header      => 'SYNOPSIS' } ],
        [ '@SHANTANU/Description', _exp('Generic'), { header      => 'DESCRIPTION' } ],
        [ '@SHANTANU/Overview',    _exp('Generic'), { header      => 'OVERVIEW' } ],

        [ '@SHANTANU/Stability', _exp('Generic'), { header => 'STABILITY' } ],
    );
    for my $plugin (
        [ 'Usage',        _exp('Collect'), { command => 'usage' } ],
        [ 'Functions',    _exp('Collect'), { command => 'func' } ],
        [ 'Attributes',   _exp('Collect'), { command => 'attr' } ],
        [ 'Constructors', _exp('Collect'), { command => 'construct' } ],
        [ 'Methods',      _exp('Collect'), { command => 'method' } ],
        [ 'Registers',    _exp('Collect'), { command => 'register' } ],
        [ 'Constants',    _exp('Collect'), { command => 'constant' } ],
      )
    {
        $plugin->[2]{header} = uc $plugin->[0];
        push @plugins, $plugin;
    }

    push @plugins,
      (
        [ '@SHANTANU/Leftovers', _exp('Leftovers'), {} ],
        [ '@SHANTANU/postlude', _exp('Region'), { region_name => 'postlude' } ],
        [
            '@SHANTANU/Badges',
            _exp('Badges'),
            {
                formats        => 'html',
                badge          => ['Perl', 'Shantanutravis', 'Cpantesters', 'Kwalitee', 'Gratipay'],
                -perl_version  => '5.10+',
                -shantanutravis_user   => 'shantanubhadoria',
                -travis_branch => 'build/master',
                -gratipay_user => 'shantanubhadoria',
            }
        ],
        [
            '@SHANTANU/Support',
            _exp('Support'),
            {
                perldoc            => 0,
                websites           => 'none',
                bugs               => 'metadata',
                bugs_content       => $bugtracker_content,
                repository_link    => 'both',
                repository_content => $repo_intro
            }
        ],
        [ '@SHANTANU/Authors', _exp('Authors'), {} ],
        [ '@SHANTANU/Contributors', _exp('Contributors'), {} ],
        [ '@SHANTANU/Legal',   _exp('Legal'),   {} ],
        [ '@SHANTANU/List', _exp('-Transformer'), { 'transformer' => 'List' } ],
      );

    return @plugins;
}
