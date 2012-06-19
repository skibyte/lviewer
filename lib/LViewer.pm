#
# LViewer - A CLOC frontend 
# Copyright (C) 2012  Fernando Castillo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

package LViewer;

use XML::Simple;
use Data::Dumper;
use Cwd 'abs_path';
use File::Basename;

sub trim
{
   my $string = shift;
   $string =~ s/^\s+|\s+$//g;
   return $string;
}
sub new
{
    my $class = shift;

    my $self = {};

    $self{'config'} = 'config.xml';

    bless $self, $class;

    return $self;
}

sub setConfigurationFile
{
    my $self = shift;
    $self{'config'} = shift;
    #print "$self{'config'}\n";
}

sub setOutputFormat
{
}

# FIXME Debug absolute paths and relative paths in config.xml
# FIXME Add supprt for console output instead of xml
# TODO Add POD Documentation

sub execute
{
    my $self = shift;
    my $output = "<?xml version=\"1.0\"?>\n<projects>";
    
    #my $config = XMLin($self{'config'}) or die 'Config file not found';
    die "Configuration file: " . $self{'config'} . " not found\n" if not -e $self{'config'};
    my $config = XMLin($self{'config'},ForceArray => 1) or die 'Config file not found';
    #my $config = XMLin('test/org/lviewer/config.xml') or die 'Config file not found';
my $basedir = trim($config->{basedir});

    my $full_path = dirname(abs_path($self{'config'}));
    my $count = 0;
    my $all_projects = "";
    #chdir $basedir;
for (keys(  %{$config->{ project }})  ) 
{
    my %language_hash = (
        'abap'         => 'ABAP',
        'actionscript'         => 'ActionScript',
        'bash'        => 'Bourne Again Shell',
        'sh'        => 'Bourne Shell',
        'c'           => 'C', 
        'csh'           => 'C Shell', 
        'c++'         => 'C++', 
        'xml'         => 'XML', 
        'java'        => 'Java', 
        'make'        => 'make',
        'javascript'  => 'Javascript',
        'perl'        => 'Perl',
        'python'        => 'Python',
        'jsp'         => 'JSP',
        'yacc'        => 'yacc',
        'lex'         => 'lex',
        'idl'         => 'IDL',
        'batch'       => 'DOS Batch',
        'css'         => 'CSS',
        'html'        => 'HTML', 
        'cmake'         => 'CMake',
        'vim'         => 'vim script',
        'yaml'         => 'YAML'
        );

    my $name = $_;
    my $path = $config->{project}->{$_}->{path};
    my $languages = $config->{project}->{$_}->{languages};
    my $exclude_path = "";
    @exclude = $config->{project}->{$_}->{exclude};

    if(defined $exclude[0])
    {
        my $var = 0;
        for(@{$exclude[0]} )
        {
            $exclude_path = $exclude_path . "$basedir/$path/$exclude[0][$var++]{dir},"; 
        }

        chop($exclude_path);
    }

    my $keep_c_header = 0;
    for(split(",", $languages))
    {
        if(trim($_) eq "c++" | trim($_) eq "c")
        {
            $keep_c_header = 1;
        }


        delete $language_hash{trim($_)};
#$languages = $languages . $language_hash{trim($_)} . ",";
    }

    my $lstr = "";
    if($keep_c_header == 0)
    {
        $lstr = $lstr . "C/C++ Header,";
    }

    foreach(keys(%language_hash))
    {
        $lstr = $lstr . $language_hash{$_} . ",";
    }

# Eliminate the last comma
    chop($lstr);
    my $tmp = "";
    if(length($exclude_path) > 0)
    {
        $tmp =  `cloc --quiet --xml --exclude-lang=\"$lstr\" $full_path/$basedir/$path --exclude-dir=\"$exclude_path\"`;
    }

    else
    {
        $tmp =  `cloc --quiet --xml --exclude-lang=\"$lstr\" $full_path/$basedir/$path`;
    }

    # Remove extra information generated by cloc but not needed by lviewer
    $tmp =~ s/.*<results>.*/<project name="$name">/g;
    $tmp =~ s/.*<\/results>.*/<\/project>/g;
    $tmp =~ s/.*text.*//g;
    $tmp =~ s/.*languages.*//g;
    $tmp =~ s/.*unique.*//g;
    $tmp =~ s/.*ignored.*//g;
    $tmp =~ s/.*xml version.*//g;
    $tmp =~ s/.*header.*//g;
    $tmp =~ s/.*cloc.*//g;
    $tmp =~ s/.*elapsed.*//g;
    $tmp =~ s/.*second.*//g;
    $tmp =~ s/.*n_files.*//g;
    $tmp =~ s/.*n_lines.*//g;
    $tmp =~ s/\n//g;
    $tmp =~ s/</\n</g;

    #$tmp =~ s/^\s*//g;

    $all_projects = $all_projects . "$name,";
    $output = $output . $tmp;
}
    $output .= "\n</projects>\n";

    chop($all_projects);

    my $xml = XMLin($output);

    $output = XMLout($xml, RootName => 'projects');
    # Creating a project that counts all the line counts
    $config->{total}{All}{projects} = $all_projects;
    while ((my $key, my $value)  = each %{$config->{total}})
    {
        my $files = 0;
        my $blank = 0;
        my $comments = 0;
        my $code = 0;

        #print "Key: $key Value: $value\n";
        my @total_projects = split /,/, $config->{total}{$key}{projects};
        foreach $project (@total_projects)
        {
            if(defined $xml->{project}{$project}{total})
            {
                $files    += $xml->{project}{$project}{total}{sum_files};
                $blank    += $xml->{project}{$project}{total}{blank};
                $comments += $xml->{project}{$project}{total}{comment};
                $code     += $xml->{project}{$project}{total}{code};
            }
        }

        $output = $output . qq(<total name="$key">\n);
        $output = $output . qq(<sum files="$files" blank="$blank" comment="$comments" code="$code"/>\n);
        $output = $output . qq(</total>\n);
    }


    return $output;
}

return 1;

