
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


print "1..33\n" ;


####
# Nested structures - a stuct within a struct
###

# create a new structure
$S3 = new Harness::S3 ;

# check we have the correct type
ok(1, $S3 =~ /^Harness::S3=HASH/) ;

$S31 = new Harness::S1 ;

# check we have the correct type
ok(2, $S31 =~ /^Harness::S1=HASH/) ;

# structure assignment
$S3->{two} = $S31 ;
$tmp = 0 ;
$tmp = $S3->{two} ;

ok(3, $S3->{two} =~ /^Harness::S1=HASH/) ;

# check new struct is all 0's
ok(4, GetStruct_S3(addressof $S3) eq "0 0 0 0.0000 0") ;

# sizeof/lengthof the complete structure
ok(5, Sizeof_S3() == sizeof $S3) ;
ok(6, Sizeof_S1() == $S3->{two}->sizeof) ;


# read/write
ok(7, $S3->{one} == 0) ;
ok(8, $S3->{three} == 0) ;

ok(9, $S31->{alpha} == 0) ;
ok(10, $S31->{beta} == 0) ;
ok(11, $S31->{gamma} == 0) ;

ok(12, $S3->{two}{alpha} == $S31->{alpha}) ;
ok(13, $S3->{two}{beta} == $S31->{beta}) ;
ok(14, $S3->{two}{gamma} == $S31->{gamma}) ;

$S3->{one} = 22 ;
ok(15, $S3->{one} == 22) ;
$S3->{three}  = 74 ;
ok(16, $S3->{three} == 74) ;
ok(17, GetStruct_S3($S3->addressof) eq "22 0 0 0.0000 74") ;

$S31->{alpha} = 102 ;
ok(18, $S31->{alpha} == 102) ;
ok(19, $S3->{two}{alpha} == 0) ;
$warn = $^W ; $^W = 0 ;
ok(20, $S31->{alpha} != S3->{two}{alpha}) ;
$^W = $warn ;
ok(21, GetStruct_S3($S3->addressof) eq "22 0 0 0.0000 74") ;

$S3->{two}{beta} = 367 ;
ok(22, $S31->{beta} == 0) ;
ok(23, $S3->{two}{beta} == 367) ;
ok(24, $S31->{beta} != $S3->{two}{beta}) ;
ok(25, GetStruct_S3($S3->addressof) eq "22 0 367 0.0000 74") ;

++ $S3->{one}  ;
ok(26, $S3->{one} == 23) ;
++ $S3->{three}  ;
ok(27, $S3->{three} == 75) ;
ok(28, GetStruct_S3($S3->addressof) eq "23 0 367 0.0000 75") ;

# read/write error cases
eval '$XX = $S3->{fred};' ;
ok(29, $@ =~ /^Unknown element 'fred'/) ;
eval '$S3->{joe} = 1 ;' ;
ok(30, $@ =~ /^Unknown element 'joe'/) ;

eval '$XX = $S3->{two}{fred};' ;
ok(31, $@ =~ /^Unknown element 'fred'/) ;
eval '$S3->{two}{joe} = 1 ;' ;
ok(32, $@ =~ /^Unknown element 'joe'/) ;

# unknown method
eval '$S3->some_method ; ' ;
ok(33, $@ =~ /^Can't locate object method "some_method"/) ;

# custom FETCH/STORE
# read-only
# write-only
# sizeof/lengthof each element of the structure

# read write of nested structure

####
# Arrays of structures
####

####
# Arrays of pointers to structures
####

####
# structure with an array in it
####

####
# structure with pointer to an array in it
####


