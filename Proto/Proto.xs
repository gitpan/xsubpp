#ifdef __cplusplus 
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

#define GetProto	if(SvPVX(cv) != NULL) 		\
			    RETVAL = SvPVX(cv) ;	\
			else				\
			    RETVAL = "No Proto" ;

MODULE = Proto		PACKAGE = Proto

REQUIRE: 1.924
PROTOTYPES: DISABLE

char *
none1(a,b)
	int a
	char * b
	CODE: GetProto ;
	OUTPUT: RETVAL

PROTOTYPES: ENABLE

char *
none2(a,b)
	int a
	char * b
	PROTOTYPE: DISABLE
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
none3()
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
none4()
	int dummy
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
none5()
        int dummy
	PROTOTYPE:
        CODE: GetProto ;
        OUTPUT: RETVAL

char *
none6(a)
	int a
        int dummy
        PROTOTYPE:
        CODE: GetProto ;
        OUTPUT: RETVAL


char *
any1(...)
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
std1(a,b)
	int a
	char * b
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
std2(a,b)
	int a
	CODE: GetProto ;
	OUTPUT: RETVAL


char *
std3(a,b)
	int a
	unsigned dummy
	char * b
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
std4(a,b,...)
	int a
	char * b
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
std5(a,b="abc",c=2)
	int a
	char * b
	int c
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
std6(a,b="abc",c=2,...)
	int a
	char * b
	int c
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
custom(a,b)
	int a
	PROTOTYPE: $%@*&*\$;\@
	CODE: GetProto ;
	OUTPUT: RETVAL

char *
alias0(a,b)
	int a
	ALIAS: alias1 = 1
	PROTOTYPE: @%$
	CODE: GetProto ;
	OUTPUT: RETVAL

