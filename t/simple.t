
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


print "1..34\n" ;

####
# Interface to existing typemap types
#####################################

####
# simple interface to an int 
####

# Check that C & Perl agree on the initial value
ok(1, Get_a == 2) ;
ok(2, $a == 2) ;

++ $a ;

# Check that C & Perl agree on the changed value
ok(3, $a == 3) ;
ok(4, Get_a == 3) ;

# addressof <<<TODO
#ok(2, Address_a == (tied $a)->addressof) ;

ok(5, Sizeof_a == (tied $a)->sizeof) ;

####
# simple interface to a double
####

# Check that C & Perl agree on the initial value
ok(6, Get_b == 1.234) ;
ok(7, $b == 1.234) ;
 
$b = 4.321 ;
 
# Check that C & Perl agree on the changed value
ok(8, $b == 4.321) ;
ok(9, Get_b == 4.321) ;

# addressof <<<TODO
#ok(2, Address_b == (tied $b)->addressof) ;

ok(10, Sizeof_b == (tied $b)->sizeof) ;

####
# simple interface to a string
# ignore the possibility of writing off the end of the string.
####

# Check that C & Perl agree on the initial value
ok(11, Get_c eq "abcde") ;
ok(12, $c eq "abcde") ;
 
$c =~ tr/a-z/A-Z/ ;
 
# Check that C & Perl agree on the changed value
ok(13, Get_c eq "ABCDE") ;
ok(14, $c eq "ABCDE") ;


# addressof <<<TODO
#ok(2, Address_c == (tied $c)->addressof) ;

ok(15, Sizeof_c == (tied $c)->sizeof) ;

####
# Check tailoring of interface
####

# read-only
####

# check the initial value
ok(16, Get_d == 77) ;

# try to write to the read-only variable
eval '$d = 1' ;
ok(17, $@ =~ /read-only/) ;

# check that the write didn't get done
ok(18, Get_d == 77) ;

# write-only
####

ok(19, Get_e == 78) ;
$e = 345 ;
ok(20, Get_e == 345) ;
eval '$X = $e' ;
ok(21, $@ =~ /cannot be read/) ;
ok(22, Get_e == 345) ;
#$e = 456 ;
#ok(20, Get_e == 456) ;
#print "e = " . Get_e . "\n" ;

# custom FETCH
####

ok(23, Get_f == 78) ;
ok(24, $f == 78 * 2) ;

# custom STORE
####

ok(25, Get_g == 78) ;
$g = 22 ;
ok(26, Get_g == 20) ;


# custom FETCH & STORE
####

ok(27, Get_h == 2001) ;
ok(28, $h == 20010) ;
$h = 20 ;
ok(29, Get_h == 25) ;
ok(30, $h == 250) ;

# alias
####

ok(31, Get_ii == 700) ;
ok(32, $i == 700) ;
$i += 20 ;
ok(33, Get_ii == 720) ;
ok(34, $i == 720) ;

