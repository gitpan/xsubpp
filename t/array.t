
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

print "1..38\n" ;


########################
# Interface to array
########################


# Dynamic Array
#################

$X = new Harness::A2 ;

# check we have the correct type
ok(1, $X =~ /^Harness::A2=ARRAY/) ;

# sizeof/lengthof
####
ok(2, $X->lengthof ==  20) ;
ok(3, ($len = $X->sizeof) ==  4) ;


# read/write
####
ok(4, $X->[0] == 0) ;
ok(5, ReadInt($X->addressof) == 0) ;
ok(6, $X->[1] == 0) ;
ok(7, ReadInt($X->addressof + $len) == 0) ;

$X->[0] = 23 ;
$X->[1] = 44 ;
ok(8, $X->[0] == 23) ;
ok(9, ReadInt($X->addressof) == 23) ;
ok(10, $X->[1] == 44) ;
ok(11, ReadInt($X->addressof + $len) == 44) ;
$X->[0] = 0xff ;
$X->[1] = -1 ;
ok(12, $X->[0] == 0xFF) ;
ok(13, ReadInt($X->addressof) == 0xFF) ;
ok(14, $X->[1] == -1) ;
ok(15, ReadInt($X->addressof + $len) == -1) ;

# read/write off end of array
####

eval ' $X->[-1] = 2 ; ' ;
ok(16, $@ =~ /^index -1 is not in range \[0..19]/) ;

eval ' $X->[20] = 2 ; ' ;
ok(17, $@ =~ /^index 20 is not in range \[0..19]/) ;

# custom FETCH/STORE
# read-only
# write-only

# Interface to an existing array
####

# make sure we agree on the initial values
ok(18, GetArray_A1 eq "5 4 3 2 1") ;
ok(19, $A1->[0] == 5) ;
ok(20, $A1->[1] == 4) ;
ok(21, $A1->[2] == 3) ;
ok(22, $A1->[3] == 2) ;
ok(23, $A1->[4] == 1) ;

# now change some of them
$A1->[2] = 7 ;
++$A1->[0] ;
$A1->[1] = $A1->[2] + $A1->[4] ;

# do we all still agree?
ok(24,  GetArray_A1 eq "6 8 7 2 1") ;
ok(25, $A1->[0] == 6) ;
ok(26, $A1->[1] == 8) ;
ok(27, $A1->[2] == 7) ;
ok(28, $A1->[3] == 2) ;
ok(29, $A1->[4] == 1) ;

# try to read/write off the end of the array
eval '$A1->[5] = 2;' ;
ok(30, $@ =~ /^index 5 is not in range \[0..4] at/) ;
eval '$A1->[-3] = 2;' ;
ok(31, $@ =~ /^index -3 is not in range \[0..4] at/) ;

eval '$XX = $A1->[23]' ;
ok(32, $@ =~ /^index 23 is not in range \[0..4] at/) ;
eval '$XX = $A1->[-3]' ;
ok(33, $@ =~ /^index -3 is not in range \[0..4] at/) ;

# get the array length
ok(34, $A1->lengthof == 5) ;

# read-only
$A3 = new Harness::A3 ;
ok(35, $A3 =~ /^Harness::A3=ARRAY/) ;
eval '$A3->[3] = 4;' ;
ok(36, $@ =~ /^array is read-only/) ;

# write-only
$A4 = new Harness::A4 ;
ok(37, $A4 =~ /^Harness::A4=ARRAY/) ;
eval '$y = $A4->[3] ;' ;
ok(38, $@ =~ /^array is write-only/) ;

# custom FETCH
# custom STORE
# custom sizeof
# custom lengthof
# custom addressof
# custom new
# custom destroy

# array of arrays
