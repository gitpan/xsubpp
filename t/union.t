
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


print "1..10\n" ;

#####
# Interface to union
#################################

# create a new union
$U1 = new Harness::U1 ;

# check we have the correct type
ok(1, $U1 =~ /^Harness::U1=HASH/) ;

# check new union is all 0's
ok(2, GetUnion_U1_int(addressof $U1) == 0) ;
ok(3, GetUnion_U1_double(addressof $U1) == 0.0) ;

# sizeof/lengthof the complete structure
ok(4, Sizeof_U1() == $U1->sizeof) ;

# read/write
ok(5, $U1->{integer} == 0) ;
ok(6, $U1->{real} == 0) ;

$U1->{integer} = 22 ;
ok(7, $U1->{integer} == 22) ;
ok(8, GetUnion_U1_int(addressof $U1) == 22) ;

$U1->{real}  = 74.87 ;
ok(9, $U1->{real} == 74.87) ;
ok(10, GetUnion_U1_double(addressof $U1) == 74.87) ;



