
#use AddINC qw(../blib) ;

use Harness ;

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

print "1..1\n" ;

ok(1, 1) ;

