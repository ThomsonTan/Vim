@rem = '--*-Perl-*--
@echo off
perl -x -S %0 %*
goto endofperl


@rem -- BEGIN PERL -- ';
#line 8
#!/usr/bin/perl
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

for (@ARGV) {
    if (/^-l/) {
        $minLines = substr $_, 2;
        $minLines += 1;
    }
    elsif (/^-L/) {
        $maxLines = substr $_, 2;
        $maxLines += 1;
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

find ({wanted => \&GetFileNames, no_chdir => 1}, '.');
if (not $FileNamePattern && @Filter_ARGV == 0) {
    #exit 0;
}

@ARGV = @Filter_ARGV;
my @cache_range = ();
my $startline = 0;

my $start_matching = 0; 
my $hasAnyOutput = 0;
while (<>) {
   chomp;
   if (/$pat1/i) {
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


__END__
:endofperl

