#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


MODULE = Alias  PACKAGE = Alias

PROTOTYPES: ENABLE

#define fred() ix
int
fred()
    ALIAS: one = 1	two = 2
	   three = 3	Yellow::four = 4


#define other()	meth_name
char *
other()
	ALIAS:	beta=2
	INIT:
		char *meth_name = GvNAME(CvGV(cv));
	ALIAS:	alpha=1
	ALIAS:	Pink::gamma=3


#define harry() ix
int
harry()
    ALIAS:	joe = 2
		harry = 4

int
third(a)
	int a
	ALIAS:	blue = 4
