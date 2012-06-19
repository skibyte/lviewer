# lviewer - A CLOC frontend
If you count constantly lines of code across multiple directories, using
lviewer might save you some time.
By creating a lviewer.cfg file in your home directory you can make permanent
your preferences where cloc will look for source code.


## Requirements
* Perl
* Cloc - http://cloc.sourceforge.net/ by Al Danail

## Install
    perl Makefile.PL
    make test
    make install

## Usage
Once lviewer is installed and you have created  $HOME/lviewer.cfg just type:
    lviewer.pl

## $HOME/lviewer.cfg sample
    <config basedir=".">

        <project name="c-project" languages="c" path="c-project">
            <exclude dir="test1"/>
            <exclude dir="test2" />
        </project>
        
        <project name="chess" languages="java,c++" path="chess">
        </projects>

    </config>

## Credits
**Author:** Fernando Castillo skibyte@gmail.com

## Bugs
If you find a bug please let me know by opening an issue at: https://github.com/skibyte/lviewer/issues

## License
lviewer is licensed under a GPL2 license. For more details see the COPYING file.
