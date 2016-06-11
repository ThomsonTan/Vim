@rem = '--*-Perl-*--
@echo off
perl -x -S %0 %*
goto :EOF


@rem -- BEGIN PERL -- ';
#!/usr/bin/perl #line should be put after this line
#line 9

use Env;
use File::Basename;
use File::Find;

if (@ARGV == 0) {
    print "Search files\n";

    exit 0;
}

$fileNamePattern = $ARGV[0];
if ($fileNamePattern =~ /\*$/) {
    $fileNamePattern .= '*';
}

my $resultMapFileName = $ENV{'PYCMD_RESULT_MAP_FILE_PATH'};
my $hasMapFile = 1;
open(my $resultMap, ">", $resultMapFileName) || ($hasMapFile = 0);

my $lineIndex = 0;

sub GetFileNames {
    my $fileName = fileparse($_);
    if (/tags/) {
# don't search ctags filefunctionDef
        return;
    }
    elsif (($fileName =~ /$fileNamePattern/i) && -f && -T) {
        my $indexChar = ' ';
        if ($lineIndex < 26) {
            $indexChar = chr(ord('a') + $lineIndex);
        }
# remove prefix "./"
        $_ = substr $_, 2;
        print $indexChar, " ", $_, "\n";
        if ($hasMapFile == 1) {
            print $resultMap $_, "\n";
        }

        $lineIndex += 1;
    }
    elsif (-d && $_ != '.' && $_ != '..') {
        find (\&GetFileNames => $_);
    }
}

find ({wanted => \&GetFileNames, no_chdir => 1}, '.');

if ($hasMapFile) {
    close($resultMap);
}

