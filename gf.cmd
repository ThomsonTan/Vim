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

my $pat1;
my $pat2;
my $minLines = 2;
my $maxLines = 10;
my $inverse_search;
my @Filter_ARGV;
my $FileNamePattern;
my $greedyMatchStartPat = 0;

if (@ARGV == 0) {
    print "Usage: $0 <pattern1> <pattern2> [-l<MinNumOfLines>] [-L<MaxNumOfLines>] [-g] [-r] [-R<FileNamePattern>] [filename [filename ...]]\n";
    print "\n";
    print "    pattern will be surrounded by match operator (/pattern1/i) in Perl.\n";
    print "    -l2 means output has 2 lines as minimum, which is default. -l1 makes no sense here.\n";
    print "    -R FileNamePattern is matched resursively.\n";
    print "    -g Match line to start pattern greedy, start line is reset when sees start pattern anytime.\n";
    print "    no wildchar in filename.\n";
    print "\n";
    exit 0;
}

for (@ARGV) {
    if (/^-l/) {
        $minLines = substr $_, 2;
    }
    elsif (/^-L/) {
        $maxLines = substr $_, 2;
    }
    elsif (/^\-r/) {
        $inverse_search = true;
    }
    elsif (/^\-R/) {
        $FileNamePattern = substr $_, 2;
    }
    elsif (!defined($pat1)) {
        $pat1 = $_;
    }
    elsif (!defined($pat2)) {
        $pat2 = $_;
    }
    elsif (/^-g/) {
        $greedyMatchStartPat = 1;
    }
    else {
        push @Filter_ARGV, $_;
    }
}

if ($inverse_search) {
    ($pat1, $pat2) = ($pat2, $pat1);
}

sub GetFileNames {
    if (/$FileNamePattern/i && -f) {
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

@ARGV = @Filter_ARGV;
my @cache_range = ();
my $startline = 0;

my $start_matching = 0; 
my $hasAnyOutput = 0;
while (<>) {
   chomp;
   if ((($greedyMatchStartPat == 1) || !$start_matching) && /$pat1/i) {
       @cache_range = ();
       $start_matching = 1;
       $startline = $.;
       push @cache_range, $_;
       next;
   }
   if ($start_matching) {
       push @cache_range, $_;
       if (@cache_range < $minLines) {
           next;
       }
       elsif (@cache_range > $maxLines) {
           $start_matching = 0;
           @cache_range = ();
       }
       elsif (/$pat2/i) {
            for (@cache_range) {
               print $ARGV, ':', $startline++, ': ', $_, "\n";
               $hasAnyOutput = 1;
           }
           print "----------------------------------------\n";

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
            print "================================================================================\n";
            $hasAnyOutput = 0;
        }
    }
}

print "\n";


__END__
:endofperl

