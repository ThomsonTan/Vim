@rem = '--*-Perl-*--
@echo off
perl -x -S %0 %*
goto :EOF


@rem -- BEGIN PERL -- ';
#!/usr/bin/perl #line should be put after this line
#line 9

use Env;
use File::Basename;

if (@ARGV == 0) {
    print "Search files\n";

    exit 0;
}

$fileNamePattern = $ARGV[0];
if ($fileNamePattern =~ /\*$/) {
    $fileNamePattern .= '*';
}

$search_depth = 1000;
if (@ARGV == 2) {
    $search_depth = int($ARGV[1]) - 1;
}

my $resultMapFileName = $ENV{'PYCMD_RESULT_MAP_FILE_PATH'};
my $hasMapFile = 1;
open(my $resultMap, ">", $resultMapFileName) || ($hasMapFile = 0);

my $lineIndex = 0;

my $current_depth = 0;

sub GetFileNames {
    my $current_dir = shift;
    my @current_files = glob($current_dir.'\*');
    foreach my $fileName (@current_files) {
        my $base_name = fileparse($fileName);
        if ($fileName =~ /tags/) {
# don't search ctags filefunctionDef
            return;
        }
# https://stackoverflow.com/questions/2601027/how-can-i-check-if-a-file-exists-in-perl
        elsif (($base_name =~ /$fileNamePattern/i)) {
            my $indexChar = ' ';
            if ($lineIndex < 26) {
                $indexChar = chr(ord('a') + $lineIndex);
            }
# remove prefix "./"
            my $print_file_name = $fileName;
            if ($print_file_name =~ /^\./) {
                $print_file_name = substr $print_file_name, 2;
            }
            print $indexChar, " ", $print_file_name, "\n";
            if ($hasMapFile == 1) {
                print $resultMap $fileName, "\n";
            }

            $lineIndex += 1;
        }

        if (-d $fileName && $current_depth < $search_depth) {
            $current_depth++;
            GetFileNames($current_dir . "\\" . $base_name);
            $current_depth--;
        }
    }
}

# find ({wanted => \&GetFileNames, no_chdir => 1}, '.');

GetFileNames(".");

if ($hasMapFile) {
    close($resultMap);
}

