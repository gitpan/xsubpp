
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

print "1..4\n" ;


## Parsing the typemap file
###########################

# a typemap entry with 1 column
$filename = "typ.test" ;
writeFile($filename, <<EOM) ;
#comment followed by a blank line

abc	def
abc	def
XYZ
EOM

$a = xsubpp "-typemap $filename x" ;
ok(1, $? != 0) ;
ok(2, $a =~ /^Warning: File '$filename' Line 5 'XYZ' TYPEMAP entry needs 2 or 3 columns/) ;

unlink $filename ;

# a typemap with an unknown TYPEMAP
$filename = "typ.test" ;
writeFile($filename, <<EOM) ;
#comment followed by a blank line

TYPEMAP fred
abc	def
abc	def
XYZ
EOM

$a = xsubpp "-typemap $filename x" ;
ok(3, $? != 0) ;
ok(4, $a =~ /^Error: File '$filename' Line 3 'TYPEMAP fred' illegal TYPEMAP/) ;

unlink $filename ;
