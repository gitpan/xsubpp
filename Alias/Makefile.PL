use ExtUtils::MakeMaker;

WriteMakefile(
		DISTNAME	=> 'Alias',
		NAME	=> 'Alias',
		VERSION	=> '2.000a2',
		XSOPT	=> '-prototypes',
		);

sub MY::postamble {
  '
Alias.c:      Alias.xs ../xsubpp ../typemap
	$(PERL) ../xsubpp  -typemap ../typemap $(XSUBPPARGS) $*.xs >$*.tc && mv $*.tc $@
  ' ;
}


