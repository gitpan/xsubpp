
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

    $cmd = "$Perl $Inc xsubpp -noprototypes $command 2>&1" ;
    `$cmd` ;
}

$Inc = '' ;
foreach (@INC)
 { $Inc .= "-I$_ " }

$Perl = '' ;
$Perl = ($ENV{'FULLPERL'} or $^X or 'perl') ;

$test = 'testfil' ;
$test1 = 'testfil1' ;
$pipe  = 'pip.tst' ;

unlink $test, $test1, $pipe ;

print "1..20\n" ;

# Error cases
#############


# empty command line
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred

INCLUDE:
EOM

$a = xsubpp($test) ;
ok(1, $? != 0) ;
ok(2, $a =~ /^INCLUDE: filename missing in $test/) ;


# missing filename
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
INCLUDE: nothere
EOM
 
$a = xsubpp($test) ;
ok(3, $? != 0) ;
ok(4, $a =~ /^Cannot open 'nothere': No such file or directory in $test, line 3/) ;


# check that the right filename is reported in a nested include.
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
INCLUDE: $test1
EOM
 
writeFile($test1, <<EOM) ;
INCLUDE: nothere
EOM

$a = xsubpp($test) ;
ok(5, $? != 0) ;
ok(6, $a =~ /^Cannot open 'nothere': No such file or directory in $test1, line 1/) ;

# check that the right filename is reported when returned from an include
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
INCLUDE: $test1

INCLUDE:
EOM
 
writeFile($test1, <<EOM) ;

EOM
 
$a = xsubpp($test) ;
ok(7, $? != 0) ;
ok(8, $a =~ /^INCLUDE: filename missing in $test, line 5/) ;


# recursion detector
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
INCLUDE: $test
 
EOM
 
$a = xsubpp($test) ;
ok(9, $? != 0) ;
ok(10, $a =~ /^INCLUDE loop detected in $test, line 3/) ;

# indirect recursion 
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
INCLUDE: $test1
 
EOM
 
writeFile($test1, <<EOM) ;
 
INCLUDE: $test
EOM
 
$a = xsubpp($test) ;
ok(11, $? != 0) ;
ok(12, $a =~ /^INCLUDE loop detected in $test1, line 2/) ;


# Working INCLUDE <<<<TODO
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
int
harry()
 
INCLUDE:  $test1
 
int
tom()
 
EOM
 
writeFile($test1, <<EOM) ;
int
joe()
EOM
 
$_ = xsubpp($test) ;
ok(13, $? == 0) ;
ok(14, (/\QnewXS("fred::harry/ and 
        /\QnewXS("fred::joe/ and 
        /\QnewXS("fred::tom/)) ;



# pipe tests

# Error case - output pipe
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
INCLUDE: | pipe
 
EOM
 
$a = xsubpp($test) ;
ok(15, $? != 0) ;
ok(16, $a =~ /^INCLUDE: output pipe is illegal in $test, line 3/) ;


# unknown command
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
INCLUDE:  $pipe|
 
EOM
 
$a = xsubpp($test) ;
ok(17, $? != 0) ;
ok(18, $a =~ /^\QError reading from pipe 'pip.tst|': No such file or directory in $test, line 3/) ;

# working pipe test 
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred
 
int 
harry()

INCLUDE:  sh $pipe |
 
int
tom()

EOM

writeFile($pipe, <<EOM) ;
echo int
echo 'joe()'
EOM
 
$_ = xsubpp($test) ;
ok(19, $? == 0) ;
ok(20, (/\QnewXS("fred::harry/ and 
	/\QnewXS("fred::joe/ and 
	/\QnewXS("fred::tom/)) ;



unlink $test, $test1, $pipe ;

exit ;
