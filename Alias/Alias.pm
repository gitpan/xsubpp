package Alias ;

use Exporter;
use AutoLoader;
use DynaLoader ;

@ISA = (Exporter, AutoLoader, DynaLoader);

@EXPORT = qw ( 
	fred one two three
	other alpha beta
	harry joe
	third blue

	) ;


bootstrap Alias ;


# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

1;
__END__
