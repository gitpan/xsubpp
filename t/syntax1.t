

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

    # ditch stdout but keep stderr
    $cmd = "$Perl $Inc xsubpp $command 3>&1 1>/dev/null 2>&3" ;
    `$cmd` ;
}

$Inc = '' ;
foreach (@INC)
 { $Inc .= "-I$_ " }

$Perl = '' ;
$Perl = ($ENV{'FULLPERL'} or $^X or 'perl') ;

$filename = "syntax.tst" ;
$typemap  = "type.tmp" ;

print "1..12\n" ;


## Check the detection of errors in function definitions
#######################################################

# an invalid MODULE line, mmm no such thing. Maybe xsubpp needs changed.


# unknown sub-section

writeFile($filename, <<EOM) ;

MODULE = test PACKAGE = test

TYPE oops

EOM

$a = xsubpp $filename  ;
ok(1, $? != 0) ;
ok(2, $a =~ /^Error: Unknown section 'TYPE oops' in $filename, line 4/) ;

# XSUB definition too short

writeFile($filename, <<EOM) ;

MODULE = test PACKAGE = test

abc

EOM

$a = xsubpp $filename  ;
ok(3, $? != 0) ;
ok(4, $a =~ /^Error: Function definition too short 'abc' in $filename, line 4/) ;

# illegal function definition

writeFile($filename, <<EOM) ;

MODULE = test PACKAGE = test

int
fred

EOM

$a = xsubpp $filename  ;
ok(5, $? != 0) ;
ok(6, $a =~ 
  /Error: Cannot parse function definition from 'fred' in $filename, line 5/) ;


# duplicate function definition

writeFile($filename, <<EOM) ;

MODULE = test PACKAGE = test

int
fred()

int
fred()

EOM

$a = xsubpp $filename  ;
ok(7, $? == 0) ;
ok(8, $a =~ 
  /Warning: duplicate function definition 'fred' detected in $filename, line 8/) ;

# unknown return type

writeFile($filename, <<EOM) ;

MODULE = test PACKAGE = test

green
fred()

EOM

$a = xsubpp $filename  ;
ok(9, $? != 0) ;
ok(10, $a =~ /Error: 'green' not in typemap in $filename, line 5/) ;

# return type in typemap but no OUTPUT definition

writeFile($typemap, <<EOM) ;

green	sometype
EOM

$a = xsubpp "-typemap $typemap $filename"  ;
ok(11, $? != 0) ;
ok(12, $a =~ 
  /Error: No OUTPUT definition for type 'green' found in $filename, line 5/) ;


unlink $filename ;
unlink $typemap ;

