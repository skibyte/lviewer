#!/usr/bin/perl -w
#
# lviewer - A CLOC frontend 
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

use LViewer;
use Getopt::Std;

# TODO Add documentation

my %args;

getopt("c:",\%args);
my $configuration = '';
if(defined $args{c})
{
    $configuration = $args{c};
}

else
{
    $configuration = $ENV{'HOME'} . '/.lviewer.cfg';
}

$lviewer = LViewer->new();

$lviewer->setConfigurationFile($configuration);
print $lviewer->execute();

