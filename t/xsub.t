
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


print "1..40\n" ;


####
# calling an XSUB which wants a structure pointer as a parameter
####

$xs1 = new Harness::S1 ;
ok(1, $xs1 =~ /^Harness::S1=HASH/) ;

# initialise the sructure
$xs1->{alpha} = 44 ;
$xs1->{beta}  = 55 ;
ok(2, $xs1->{alpha} == 44) ;
ok(3, $xs1->{beta} == 55) ;

# call the xsub
$x = XS1($xs1, 10) ;

# check the return value
ok(4, $x == 54) ;

# & check that the structure has been modified
ok(5, $xs1->{alpha} == 44) ;
ok(6, $xs1->{beta} == 56) ;

####
# calling an XSUB which wants a structure as a parameter
####

$xs2 = new Harness::S1 ;
ok(7, $xs2 =~ /^Harness::S1=HASH/) ;
 
$xs2->{alpha} = 2 ;
$xs2->{beta}  = 43 ;
ok(8, $xs2->{alpha} == 2) ;
ok(9, $xs2->{beta} == 43) ;
 
$x = XS2($xs2, 7) ;
ok(10, $x == 14) ;

# check the original structure has not been changed
ok(11, $xs2->{alpha} == 2) ;
ok(12, $xs2->{beta} == 43) ;

####
# calling an XSUB which wants to return a structure pointer
####

$x = XS3(123,456, 7.89) ;

# check returned ok
ok(13, $x =~ /^Harness::S1=HASH/) ;

# is the address ok?
ok(14, Addressof_XS3_struct == addressof $x) ;

# check that the returned structure is as we have initialised it
ok(15, $x->{alpha} == 123) ;
ok(16, $x->{beta} == 456) ;
ok(17, $x->{gamma} == 7.89) ;

# check what C thinks
ok(18, GetStruct_S1(Addressof_XS3_struct) eq "123 456 7.8900") ;

# now modify the structure
$x->{alpha} = 7 ;
$x->{beta} += 34 ;
$x->{gamma} = 4.99 ;

ok(19, $x->{alpha} == 7) ;
ok(20, $x->{beta} == 490) ;
ok(21, $x->{gamma} == 4.99) ;

# check what C thinks
ok(22, GetStruct_S1(Addressof_XS3_struct) eq "7 490 4.9900") ;

# calling XS3 again should return the same pointer
$y = XS3(2, 65, 9.1) ;
ok(23, addressof $x eq addressof $y) ;

ok(24, $x->{alpha} == 2) ;
ok(25, $x->{beta} == 65) ;
ok(26, $x->{gamma} == 9.1) ;

ok(27, $x->{alpha} == $y->{alpha}) ;
ok(28, $x->{beta} == $y->{beta}) ;
ok(29, $x->{gamma} == $y->{gamma}) ;

####
# calling an XSUB which wants to return a structure 
####


$x = XS4(123, 456, 73.2) ;
ok(30, $x =~ /^Harness::S1=HASH/) ;
ok(31, $x->{alpha} == 123) ;
ok(32, $x->{beta} == 456) ;
ok(33, $x->{gamma} == 73.2) ;

# calling XS4 again should return a new structure

$y = XS4(29, 5, 0.3) ;
ok(34, $y =~ /^Harness::S1=HASH/) ;
ok(35, $y->{alpha} == 29) ;
ok(36, $y->{beta} == 5) ;
ok(37, $y->{gamma} == 0.3) ;

# and that shouldn't have changes the previous structure
ok(38, $x->{alpha} == 123) ;
ok(39, $x->{beta} == 456) ;
ok(40, $x->{gamma} == 73.2) ;

#  need examples using arrays & scalars
