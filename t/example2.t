
#use AddINC qw(../blib) ;

use Harness ;

$total = $ok = 0 ;
$trace = 0 ;

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
    my($p, $word) = @_ ;
    my ($cond) ;

    print "addtree ($p, $word) " . addressof $p . "\n"  if $trace ;
    if (addressof $p == addressof  $NULL) {
    #if ($p == $NULL) {
	$p = new Harness::tnode ;
	$p->{word} = $word ;
	$p->{count} = 1 ;
	$p->{left} = $NULL ;
	$p->{right} = $NULL ;
	return $p ;
    }
    if (($cond = ($word cmp $p->{word})) == 0) {
	$p->{count} ++ ; print "$word = $p->{count}\n" if $trace
    }
    elsif ($cond < 0) {
	print "Going Left\n" if $trace;
	$p->{left} = addtree($p->{left}, $word)
    }
    else {
	print "Going Right\n" if $trace;
	$p->{right} = addtree($p->{right}, $word)
    }

    return $p ;
}

sub treeprint
{
    my($p) = @_ ;

    print "treeprint $p\n" if $trace;

    #if ($p != $NULL) {
    if (addressof $p != addressof $NULL) {
	treeprint($p->{left}) ;
	print "$p->{word}	$p->{count}\n" if $trace;
	push @Result, $p->{word}, $p->{count} ;
	treeprint($p->{right}) ;
    }
}

# create a new structure
#$NULL = new Harness::tnode, 0 ;
$NULL = new Harness::tnode ;
$root = $NULL ;
print "NULL = $NULL " . addressof $NULL . "\n" if $trace;

@words = qw(the cat sat on the hat) ;
#@numbers = qw(1 3 1 5 2 5 7 1 3) ;

foreach (@words)
{
    $root = addtree($root, $_) ;
}

treeprint ($root) ;

print "1..1\n" ;
ok(1, "@Result" eq 'cat 1 hat 1 on 1 sat 1 the 2') ;
