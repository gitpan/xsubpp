use ExtUtils::MakeMaker 5.16 ;

# The 1.* core tests
@main::Ver1Tests = grep (s#(.*)#t/$1.t#,  
			qw(cmdline typemap syntax1 alias require proto include)) ;

# the 2.* test
@main::Ver2Tests = grep (s#(.*)#t/$1.t#, 
		qw(simple struct1 struct2 union array scalar xsub 
		)) ;

		 #example1 example2 example3

WriteMakefile(
		#DISTNAME	=> 'XSUBPP-alpha',
		#NAME		=> 'XSUBPP',
		VERSION_FROM	=> 'xsubpp',
		INC		=> '-I.',
		XSOPT		=> '-noprototypes',
		dist		=> {COMPRESS=>'gzip', SUFFIX=>'gz'},
	        'linkext'   => {LINKTYPE => ''},

		);


#sub MY::postamble {
#  '
#Harness.c:	Harness.xs ./xsubpp ./typemap
#	$(PERL) ./xsubpp  -typemap ./typemap $(XSUBPPARGS) $*.xs >$*.tc && mv $*.tc $@
#  ' ;
#}



sub MY::test {

  q#

TEST_VERBOSE=0

test :: all
	FULLPERL=$(FULLPERL) ; export FULLPERL ; \
	$(FULLPERL) -I$(INST_ARCHLIB) -I$(INST_LIB) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -e 'use Test::Harness qw(&runtests $$verbose); $$verbose=$(TEST_VERBOSE); runtests @ARGV;' # . "@main::Ver1Tests @main::Ver2Tests" . q#

mytest :: all
	FULLPERL=$(FULLPERL) ; export FULLPERL ; \
	$(FULLPERL) -I$(INST_ARCHLIB) -I$(INST_LIB) -I$(PERL_ARCHLIB) -I$(PERL_LIB) mytest
#  
}

