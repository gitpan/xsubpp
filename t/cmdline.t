
#use AddINC qw(../blib) ;

$total = $ok = 0 ;

sub ok
{
    my($no, $test) = @_ ;

    ++ $ok if $test ;
    ++ $total ;

    if ($test)
      { print "ok $no\n" }
    else
      { print "not ok $no\n" }
}

sub readFile
{
    my ($filename) = @_ ;
    my ($string) ;

    open (F, "<$filename") 
	or die "Cannot open $filename: $!\n" ;
    while (<F>)
      { $string .= $_ }
    close F ;
    $string ;
}

sub writeFile
{
    my($filename, @strings) = @_ ;
    open (F, ">$filename") 
	or die "Cannot open $filename: $!\n" ;
    foreach (@strings)
      { print F }
    close F ;
}

sub xsubpp
{
    my($command) = @_ ;

    $cmd = "$Perl $Inc xsubpp $command 2>&1" ;
    `$cmd` ;
}

$Inc = '' ;
foreach (@INC)
 { $Inc .= "-I$_ " }

$Perl = '' ;
$Perl = ($ENV{'FULLPERL'} or $^X or 'perl') ;


print "1..20\n" ;

## Command line tests
#####################


# empty command line
$a = xsubpp '' ;
ok(1, $? != 0) ;
ok(2, $a =~ /^Usage: xsubpp/) ;

# unknown command line option
$a = xsubpp '-fred' ;
ok(3, $? != 0) ;
ok(4, $a =~ /^Usage: xsubpp/) ;

# incomplete option
$a = xsubpp '-typemap' ;
ok(5, $? != 0) ;
ok(6, $a =~ /^Usage: xsubpp/) ;

# incomplete option
$a = xsubpp '-s' ;
ok(7, $? != 0) ;
ok(8, $a =~ /^Usage: xsubpp/) ;

# options ok, but no .xs file
$a = xsubpp '-C++ ' ;
ok(9, $? != 0) ;
ok(10, $a =~ /^Usage: xsubpp/) ;

# unknown typemap file specified
$a = xsubpp '-typemap unknown x' ;
ok(11, $? != 0) ;
ok(12, $a =~ /^Can't find unknown in/) ;

# -v option
$a = xsubpp '-v' ;
ok(13, $? == 0) ;
ok(14, $a =~ /^xsubpp version \d+\.\d+/) ;

# non-text typemap file ignored
$filename = "abc" ;
writeFile($filename, "\xff\xff\xff\xff\xff\xff\xff") ;
$a = xsubpp "-typemap $filename x" ;
ok(15, $? != 0) ;
ok(16, $a =~ /^Warning: ignoring non-text typemap file '$filename'/) ;

unlink $filename ;

# unknown .xs file
$a = xsubpp 'unknown' ;
ok(17, $? != 0) ;
ok(18, $a =~ /^cannot open unknown: No such file or directory/) ;

# read script from stdin <<TODO
$filename = "abc" ;
writeFile($filename, "testing, testing, 1,2,3\n") ;
$a = xsubpp "- <$filename" ;
ok(19, $? == 0) ;
#ok(18, $a =~ /testing, testing, 1,2,3$/) ;
$x = quotemeta <<EOM ;
 *    ANY CHANGES MADE HERE WILL BE LOST!
 *
 */

testing, testing, 1,2,3
EOM
ok(20, $a =~ /$x$/) ;

unlink $filename ;
