use Proto ;

$total = $ok = 0 ;

sub ok($$)
{
    my($no, $test) = @_ ;

    ++ $ok if $test ;
    ++ $total ;

    if ($test)
      { print "ok $no\n" }
    else
      { print "not ok $no\n" }
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


print "1..17\n" ;

# Error cases
#############


unlink $test ;

# empty command line
writeFile($test, <<EOM) ;
MODULE = fred PACKAGE = fred

int
fred()
    PROTOTYPE: ENABLE
    PROTOTYPE: ENABLE
EOM

$a = xsubpp($test) ;
ok(1, $? != 0) ;
ok(2, $a =~ /^Error: Only 1 PROTOTYPE definition allowed per xsub in testfil, line 6/) ;

unlink $test ;


# Non Error Cases
# ###############

ok(3, none1(1,2) eq 'No Proto') ;
ok(4, none2(1,2) eq 'No Proto') ;
ok(5, none3() eq '') ;
ok(6, none4() eq '') ;
ok(7, none5() eq '') ;
#ok(8, none6(1) eq '') ;
ok(8, any1() eq ';@') ;
ok(9, std1(1,2) eq '$$') ;
ok(10, std2(1,2) eq '$$') ;
ok(11, std3(1,2) eq '$$') ;
ok(12, std4(1,2) eq '$$;@') ;
ok(13, std5(1,2) eq '$;$$') ;
ok(14, std6(1,2) eq '$;$$@') ;
ok(15, custom(1,2) eq '$%@*&*\$;\@') ;
ok(16, alias0(1,2) eq '@%$') ;
ok(17, alias1(1,2) eq '@%$') ;

