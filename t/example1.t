
#use AddINC qw(../blib) ;

use Harness ;

$total = $ok = 0 ;
$trace = 1 ;

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



sub addtree
{
    my($p, $number) = @_ ;
    my ($cond) ;

    print "addtree ($p, $number) " . addressof $p . "\n" 
	if $trace ;
    if (addressof $p == addressof  $NULL) {
    #if ($p == $NULL) {
print "    NEW\n" if $trace ;
	my $p = new Harness::tnode ;
print "    NEWed\n" if $trace ;
	$p->{number} = $number ;
	$p->{count} = 1 ;
print "    Setting left\n" if $trace ;
	$p->{left} = $NULL ;
print "    Setting right\n" if $trace ;
	$p->{right} = $NULL ;
print "    Set left & right\n" if $trace ;
	return $p ;
    }
    if (($cond = ($number <=> $p->{number})) == 0) {
	print "Match\n" if $trace ;
	$p->{count} ++ ; print "$number = $p->{count}\n" if $trace
    }
    elsif ($cond < 0) {
	print "Going Left\n" if $trace ;
	$p->{left} = addtree($p->{left}, $number) ;
	print "Gone Left\n" if $trace ;
    }
    else {
	print "Going Right\n" if $trace ;
	$p->{right} = addtree($p->{right}, $number) ;
	print "Gone Right\n" if $trace ;
    }

    print "End of addtree for $number\n" if $trace ;
    return $p ;
}

sub treeprint
{
    my($p) = @_ ;

    print "treeprint $p\n" if $trace ;

    #if ($p != $NULL) {
    if (addressof $p != addressof $NULL) {
	treeprint($p->{left}) ;
	print "$p->{number}	$p->{count}\n" if $trace ;
	push @Result, $p->{number}, $p->{count} ;
	treeprint($p->{right}) ;
    }
}

{
# create a new structure
#$NULL = new Harness::tnode, 0 ;
$NULL = new Harness::tnode ;
$root = $NULL ;
print "NULL = $NULL " . addressof $NULL . "\n" if $trace ;

#@words = qw(the cat sat on the hat) ;
@numbers = qw(1 3 1 5 2 5 7 1 3) ;

foreach (@numbers)
{
    $root = addtree($root, $_) ;
}

print "all added\n" if $trace ;
treeprint ($root) ;

print "1..1\n" ;
ok(1, "@Result" eq "1 3 2 1 3 2 5 2 7 1" ) ;
}
print "done1\n" ;
$NULL = $root = 1 ;
print "done\n" ;
