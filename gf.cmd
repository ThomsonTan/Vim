@rem = '--*-Perl-*--
@echo off
perl -x -S %0 %*
goto endofperl


@rem -- BEGIN PERL -- ';
#!/usr/bin/perl #line should be put after this line
#line 9
# Search keywords in multiple lines in given files, or file names in given pattern
# under current directory
#grep -oPz 'key1(.*\n){l,L}.*key1' file.txt could do the same

use File::Find;
use Term::ANSIColor;

my $pat1;
my $pat2;
my $minLines = 2;
my $maxLines = 10;
my $inverse_search;
my @Filter_ARGV;
my $FileNamePattern;
my $greedyMatchStartPat = 0;
my $caseInsensitiveMatch = 0;
my $findDefPattern = 0;

my $resultMapFileName = $ENV{'PYCMD_RESULT_MAP_FILE_PATH'};
my $hasMapFile = 1;
open(my $resultMap, ">", $resultMapFileName) || ($hasMapFile = 0);

my $lineIndex = 0;

if (@ARGV == 0) {
    print "Usage: $0 <pattern1> [-e<pattern2>] [-l<MinNumOfLines>] [-L<MaxNumOfLines>] [-d] [-i] [-g] [-R] [-r<FileNamePattern>] [filename [filename ...]]\n";
    print "\n";
    print "    pattern will be surrounded by match operator (/pattern1/) in Perl.\n";
    print "    -l2 means output has 2 lines as minimum, which is default. -l1 makes no sense here.\n";
    print "    -i Do case-insensitive match in all regexp match.\n";
    print "    -R Inverse the order of search patterns.\n";
    print "    -r FileNamePattern is matched resursively.\n";
    print "    -g Match line to start pattern greedy, start line is reset when sees start pattern anytime.\n";
    print "    no wildchar in filename.\n";
    print "\n";
    exit 0;
}

for (@ARGV) {
    if (/^[-\/]/) {
        if (/^.l/) {
            $minLines = substr $_, 2;
        }
        elsif (/^.L/) {
            $maxLines = substr $_, 2;
        }
        elsif (/^.R/) {
            $inverse_search = true;
        }
        elsif (/^.r/) {
            $FileNamePattern = substr $_, 2;
        }
        elsif (/^.g/) {
            $greedyMatchStartPat = 1;
        }
        elsif (/^.i$/) {
            $caseInsensitiveMatch = 1;
        }
        elsif (/^.e/) {
            $pat2 = substr $_, 2;
        }
        elsif (/^.d$/) {
            $findDefPattern = 1;
        }
        else {
            die("Unknown option " . $_);
        }
    }
    elsif (!defined($pat1)) {
        $pat1 = $_;
    }
    else {
        push @Filter_ARGV, $_;
    }
}

if ($caseInsensitiveMatch == 1) {
    if (defined($pat1)) {
        $pat1 = "(?i)" . $pat1;
    }
    if (defined($pat2)) {
        $pat2 = "(?i)" . $pat2;
    }
}

if ($inverse_search) {
    ($pat1, $pat2) = ($pat2, $pat1);
}

if ($findDefPattern == 1) {
# apply function name heuristics on pattern 1
# Use non-capture group here
    $pat1 = "(?:^|[^>])(" . $pat1 . ")(?:.*[^;]|)\s*\$";
}

sub GetFileNames {
    if (/tags/) {
# don't search ctags filefunctionDef
        return;
    }
    elsif (/$FileNamePattern/i && -T) {
        push @Filter_ARGV, $_;
    }
    elsif (-d && $_ != '.' && $_ != '..') {
        find (\&GetFileNames => $_);
    }
}

if (defined($FileNamePattern) || @Filter_ARGV == 0) {
    find ({wanted => \&GetFileNames, no_chdir => 1}, '.');
}
if (@Filter_ARGV == 0) {
    print "No files for searching\n\n";
    exit 0;
}

my $currentColorIndex = 0;
my $currentColor = color("green");
my $currentBrightColor = color("bright_green");
my $defaultColor = color("reset");

sub SwitchColor {
    if ($currentColorIndex == 1) {
        $currentColorIndex = 0;
        $currentColor = color("green");
        $currentBrightColor = color("bright_green");
    }
    else {
        $currentColorIndex = 1;
        $currentColor = color("red");
        $currentBrightColor = color("bright_red");
    }
}

@ARGV = @Filter_ARGV;
my @cache_range = ();
my $startline = 0;

my $start_matching = 0; 
my $hasAnyOutput = 0;
while (<>) {
   chomp;
   if ((($greedyMatchStartPat == 1) || !$start_matching) && /$pat1/) {
       @cache_range = ();
       $start_matching = 1;
       $startline = $.;
       push @cache_range, $_;
       if (defined($pat2)) {
           next;
       }
   }
   if ($start_matching) {
       if (defined($pat2)) {
           push @cache_range, $_;
       }
       if (@cache_range < $minLines && defined($pat2)) {
           next;
       }
       elsif (@cache_range > $maxLines) {
           $start_matching = 0;
           @cache_range = ();
       }
       elsif (!defined($pat2) or /$pat2/) {
           my $iterLineNum = 0;
            for (@cache_range) {
# remove prefix ./
               my $currFileName = substr $ARGV, 2;
               my $indexChar = ' ';
               if ($lineIndex < 26) {
                   $indexChar = chr(ord('a') + $lineIndex);
               }
               $lineIndex += 1;
# output line index
               print $defaultColor, $indexChar , ' ';
               if ($hasMapFile == 1) {
                   print $resultMap $currFileName, ':', $startline, "\n";
               }

#output file name and match line, with search pattern highlighted
               print $currentColor, $currFileName, ':', $startline++, ': ';
               if ($iterLineNum == 0 or $iterLineNum == $#cache_range) {
                   my $highlightPat;
                   if ($iterLineNum == 0) {
                       $highlightPat = $pat1;
                   }
                   elsif ($iterLineNum == $#cache_range and defined($pat2)) {
                       $highlightPat = $pat2;
                   }
                   my $outputStr = $_;
                   my $outputStart = 0;
                   my $matchId = $findDefPattern;
                   if (defined($highlightPat)) {
                       while (/$highlightPat/g) {
                           print $currentColor, substr($outputStr, $outputStart, $-[$matchId] - $outputStart);
                           print $currentBrightColor, substr($outputStr, $-[$matchId], $+[$matchId] - $-[$matchId]);
                           $outputStart = $+[$matchId];
                       }
                   }
                   print $currentColor, substr($outputStr, $outputStart);
               }
               else {
# for interior lines (not the first one and last one), just follow the color
                   print $_;
               }
               print "\n";
               $iterLineNum++;
               $hasAnyOutput = 1;
           }
           print $defaultColor;
           if ($hasAnyOutput == 1) {
               SwitchColor();
           }

           $start_matching = 0;
           @cache_range = ();
       }
   }
} continue {
    if (eof) {
        close ARGV;
        $start_matching = 0;
        @cache_range = ();
        if ($hasAnyOutput ) {
# only output separator line for multi-line search
            if (defined($pat2)) {
                print "--------------------------------------------------------------------------------\n";
            }
            $hasAnyOutput = 0;
        }
    }
}

__END__
:endofperl

