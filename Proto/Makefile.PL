use ExtUtils::MakeMaker;

WriteMakefile(
		DISTNAME	=> 'Proto',
		NAME	=> 'Proto',
		VERSION	=> '2.000a2',
		);

sub MY::postamble {
  '
Proto.c:      Proto.xs ../xsubpp ../typemap
	$(PERL) ../xsubpp  -typemap ../typemap $(XSUBPPARGS) $*.xs >$*.tc && mv $*.tc $@
  ' ;
}


