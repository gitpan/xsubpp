package Proto;

require Exporter;
require DynaLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	none1 none2 none3 none4 none5 none6
	any1
	std1 std2 std3 std4 std5 std6
	custom
	alias0 alias1
	
);
bootstrap Proto;

# Preloaded methods go here.

# Autoload methods go after __END__, and are processed by the autosplit program.

1;
__END__
