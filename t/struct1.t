
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


print "1..82\n" ;

#####
# Interface to dynamic structure
#################################

# create a new structure
$S1 = new Harness::S1 ;

# check we have the correct type
ok(1, $S1 =~ /^Harness::S1=HASH/) ;

# check new struct is all 0's
ok(2, GetStruct_S1(addressof $S1) eq "0 0 0.0000") ;

# sizeof/lengthof the complete structure
ok(3, Sizeof_S1() == $S1->sizeof) ;

# read/write
ok(4, $S1->{alpha} == 0) ;
ok(5, $S1->{beta} == 0) ;
ok(6, $S1->{gamma} == 0) ;

$S1->{alpha} = 22 ;
ok(7, $S1->{alpha} == 22) ;
$S1->{beta}  = 74 ;
ok(8, $S1->{beta} == 74) ;
$S1->{gamma} = 234.5678 ;
ok(9, $S1->{gamma} == 234.5678) ;
ok(10, GetStruct_S1($S1->addressof) eq "22 74 234.5678") ;

++ $S1->{alpha}  ;
ok(11, $S1->{alpha} == 23) ;
++ $S1->{beta}  ;
ok(12, $S1->{beta} == 75) ;
++ $S1->{gamma} ;
ok(13, $S1->{gamma} == 235.5678) ;
ok(14, GetStruct_S1($S1->addressof) eq "23 75 235.5678") ;

# read/write error cases
eval '$XX = $S1->{fred};' ;
ok(15, $@ =~ /^Unknown element 'fred'/) ;
eval '$S1->{joe} = 1 ;' ;
ok(16, $@ =~ /^Unknown element 'joe'/) ;

# unknown method
eval '$S1->some_method ; ' ;
ok(17, $@ =~ /^Can't locate object method "some_method"/) ;

# custom FETCH
ok(18, $S1->{dummy1} == 98 ) ;

# read-only
eval '$S1->{dummy1} = 2 ; ' ;
ok(19, $@ =~ /element 'dummy1' is read-only/) ;

# write-only
eval '$X = $S1->{dummy2} ; ' ;
ok(20, $@ =~ /element 'dummy2' is write-only/) ;

# custom STORE
$S1->{dummy2} = 7 ;
ok(21, $S1->{alpha} == 8) ;
ok(22, $S1->{beta}  == 6) ;



####
# Interface to existing structure
####

# create a reference to an existing structure
$st1 = new Harness::S1 (Addressof_s1) ;
 
# check we have the correct type
ok(23, $st1 =~ /^Harness::S1=HASH/) ;
 
# check we both agree on the address of the structure
ok(24, Addressof_s1 == $st1->addressof) ;

# check existing structure is as initialised in the .xs file
ok(25, GetStruct_S1($st1->addressof) eq "2 3 4.5000") ;
ok(26, GetStruct_S1(Addressof_s1) eq "2 3 4.5000") ;
 
# sizeof/lengthof the complete structure
ok(27, Sizeof_S1() == $st1->sizeof) ;
 
# read/write
ok(28, $st1->{alpha} == 2) ;
ok(29, $st1->{beta} == 3) ;
ok(30, $st1->{gamma} == 4.5) ;
 
$st1->{alpha} = 22 ;
ok(31, $st1->{alpha} == 22) ;
$st1->{beta}  = 74 ;
ok(32, $st1->{beta} == 74) ;
$st1->{gamma} = 234.5678 ;
ok(33, $st1->{gamma} == 234.5678) ;
ok(34, GetStruct_S1($st1->addressof) eq "22 74 234.5678") ;
 
++ $st1->{alpha}  ;
ok(35, $st1->{alpha} == 23) ;
++ $st1->{beta}  ;
ok(36, $st1->{beta} == 75) ;
++ $st1->{gamma} ;
ok(37, $st1->{gamma} == 235.5678) ;
ok(38, GetStruct_S1($st1->addressof) eq "23 75 235.5678") ;
 
# read/write error cases
eval '$XX = $st1->{fred};' ;
ok(39, $@ =~ /^Unknown element 'fred'/) ;
eval '$st1->{joe} = 1 ;' ;
ok(40, $@ =~ /^Unknown element 'joe'/) ;
 
# unknown method
eval '$st1->some_method ; ' ;
ok(41, $@ =~ /^Can't locate object method "some_method"/) ;
 
# custom FETCH/STORE
# read-only
# write-only
 
 
 




####
# Nested structures - a stuct with pointer to a struct
###

# create a new structure
$S2 = new Harness::S2 ;

# check we have the correct type
ok(42, $S2 =~ /^Harness::S2=HASH/) ;

$S21 = new Harness::S1 ;

# check we have the correct type
ok(43, $S21 =~ /^Harness::S1=HASH/) ;

# structure assignment
$S2->{blue} = $S21 ;

ok(44, $S2->{blue} =~ /^Harness::S1=HASH/) ;

# check new struct is all 0's
ok(45, GetStruct_S2(addressof $S2) eq "0 0 0 0.0000 0 0.0000") ;

# sizeof/lengthof the complete structure
ok(46, Sizeof_S2() == sizeof $S2) ;
ok(47, Sizeof_S1() == $S2->{blue}->sizeof) ;

ok(48, addressof $S21 == addressof { $S2->{blue} }) ;

# read/write
ok(49, $S2->{red} == 0) ;
ok(50, $S2->{green} == 0) ;
ok(51, $S2->{yellow} == 0) ;

ok(52, $S21->{alpha} == 0) ;
ok(53, $S21->{beta} == 0) ;
ok(54, $S21->{gamma} == 0) ;

ok(55, $S2->{blue}{alpha} == $S21->{alpha}) ;
ok(56, $S2->{blue}{beta} == $S21->{beta}) ;
ok(57, $S2->{blue}{gamma} == $S21->{gamma}) ;

$S2->{red} = 22 ;
ok(58, $S2->{red} == 22) ;
$S2->{green}  = 74 ;
ok(59, $S2->{green} == 74) ;
$S2->{yellow} = 234.5678 ;
ok(60, $S2->{yellow} == 234.5678) ;
ok(61, GetStruct_S2($S2->addressof) eq "22 0 0 0.0000 74 234.5678") ;

$S21->{alpha} = 102 ;
ok(62, $S21->{alpha} == 102) ;
ok(63, $S2->{blue}{alpha} == 102) ;
ok(64, $S21->{alpha} == $S2->{blue}{alpha}) ;
ok(65, GetStruct_S2($S2->addressof) eq "22 102 0 0.0000 74 234.5678") ;

$S2->{blue}{beta} = 367 ;
ok(66, $S21->{beta} == 367) ;
ok(67, $S2->{blue}{beta} == 367) ;
ok(68, $S21->{beta} == $S2->{blue}{beta}) ;
ok(69, GetStruct_S2($S2->addressof) eq "22 102 367 0.0000 74 234.5678") ;

++ $S2->{red}  ;
ok(70, $S2->{red} == 23) ;
++ $S2->{green}  ;
ok(71, $S2->{green} == 75) ;
++ $S2->{yellow} ;
ok(72, $S2->{yellow} == 235.5678) ;
ok(73, GetStruct_S2($S2->addressof) eq "23 102 367 0.0000 75 235.5678") ;

# read/write error cases
eval '$XX = $S2->{fred};' ;
ok(74, $@ =~ /^Unknown element 'fred'/) ;

eval '$S2->{joe} = 1 ;' ;
ok(75, $@ =~ /^Unknown element 'joe'/) ;

eval '$XX = $S2->{blue}{fred};' ;
ok(76, $@ =~ /^Unknown element 'fred'/) ;
eval '$S2->{blue}{joe} = 1 ;' ;
ok(77, $@ =~ /^Unknown element 'joe'/) ;

# unknown method
eval '$S2->some_method ; ' ;
ok(78, $@ =~ /^Can't locate object method "some_method"/) ;

# custom FETCH/STORE
# read-only
# write-only
# sizeof/lengthof each element of the structure

# create a new structure
$S4 = new Harness::S4 ;

# check we have the correct type
ok(79, $S4 =~ /^Harness::S4=HASH/) ;

# custom lengthof
ok(80, $S4->lengthof == 2345) ;

# custom sizeof
ok(81, $S4->sizeof == 100) ;

# custom addressof
#ok(81, $S4->addressof == 7654) ;
ok(82, addressof $S4 == 7654) ;

# custom clone
# TODO

# custom DESTROY
# TODO


# read write of nested structure



