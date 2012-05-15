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

use Test::More qw( no_plan );
$expected_xml = <<END;
<projects>
  <project name="chess">
    <language name="C++" blank="3" code="8" comment="0" files_count="1" />
    <language name="Java" blank="2" code="10" comment="0" files_count="1" />
    <total blank="5" code="18" comment="0" sum_files="2" />
  </project>
  <project name="myperlproject">
    <language name="Perl" blank="1" code="2" comment="0" files_count="1" />
    <total blank="1" code="2" comment="0" sum_files="1" />
  </project>
  <project name="pacman_frontend">
    <language name="Java" blank="2" code="7" comment="0" files_count="1" />
    <total blank="2" code="7" comment="0" sum_files="1" />
  </project>
</projects>
<total name="All">
<sum files="4" blank="8" comment="0" code="27"/>
</total>
<total name="All projects">
<sum files="4" blank="8" comment="0" code="27"/>
</total>
<total name="Two projects">
<sum files="3" blank="6" comment="0" code="20"/>
</total>
END

my $lviewer = LViewer->new();

$lviewer->setConfigurationFile('t/config.xml');
$lviewer->setOutputFormat('xml');
my $result = $lviewer->execute();
ok($expected_xml eq $result, "testxml");
