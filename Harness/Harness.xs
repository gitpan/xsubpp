#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
 
static void DumpInternalObj() ;

int	a = 2 ;
double	b = 1.234 ;
/* char	c[20] = "abcde" ; */
char *  c = "abcde" ;
int 	d = 77 ;
int 	e = 78 ;
int 	f = 78 ;
int 	g = 78 ;
int 	h = 2001 ;
int 	ii = 700 ;

int	A1 [] = { 5, 4, 3, 2, 1 } ; 

struct S1 {
	int	alpha ;
	short	beta ;
	double	gamma ;
	} S1 ;

struct S2 {
	int	red ;
	struct S1 * blue ;
	short	green ;
	double	yellow ;
	} S2 ;

struct S3 {
	int	one ;
	struct S1  two ;
	short	three ;
	} S3 ;

struct S4 {
	int	alpha ;
	short	beta ;
	} S4 ;

struct S1 s1 = { 2, 3, 4.5 } ;
struct S2 s2 = { 2, &s1, 3, 4.5 } ;

union U1 {
	int	integer ;
	double	real ;
	} U1 ;

struct tnode {
	char *	word ;
	int	number ;
	char	fixed [10] ;
	int	count ;
	struct tnode *	left ;
	struct tnode *	right ;
	} ;

char string[200] ;

#define ReadInt(a)	(*(int*)a)

#define Get_a()	a
#define Get_b()	b
#define Get_c()	c
#define Get_d()	d
#define Get_e()	e
#define Get_f()	f
#define Get_g()	f
#define Get_h()	h
#define Get_ii()	ii	
#define GetArray_A1()	(sprintf(string, "%d %d %d %d %d", \
			A1[0], A1[1], A1[2], A1[3], A1[4]), string)

#define Addressof_a()	((void*)&a)
#define Addressof_b()	((void*)&b)
#define Addressof_c()	((void*)&c)
#define Addressof_s1()	((void*)&s1)

#define Sizeof_a()	sizeof(a)
#define Sizeof_b()	sizeof(b)
#define Sizeof_c()	sizeof(c)
#define Sizeof_S1()	sizeof(struct S1)
#define Sizeof_S1_alpha()	sizeof(int)
#define Sizeof_S1_beta()	sizeof(short)
#define Sizeof_S1_gamma()	sizeof(double)

#define Sizeof_S2()	sizeof(struct S2)

#define GetStruct_S1(s)	(sprintf(string, "%d %d %0.4f", \
			((struct S1*)s)->alpha, \
			((struct S1*)s)->beta, \
			((struct S1*)s)->gamma), string) ;

#define GetStruct_S2(s)	(sprintf(string, "%d %d %d %0.4f %d %0.4f", \
	((struct S2*)s)->red, \
	((struct S2*)s)->blue->alpha, \
	((struct S2*)s)->blue->beta, \
	((struct S2*)s)->blue->gamma, \
	((struct S2*)s)->green, \
	((struct S2*)s)->yellow), string) ;

#define DumpStruct_S2(s) (sprintf(string, "%d %X %d %0.4f", \
        ((struct S2*)s)->red, \
        ((struct S2*)s)->blue, \
        ((struct S2*)s)->green, \
        ((struct S2*)s)->yellow), string) ;

#define GetStruct_S3(s)	(sprintf(string, "%d %d %d %0.4f %d", \
	((struct S3*)s)->one, \
	((struct S3*)s)->two.alpha, \
	((struct S3*)s)->two.beta, \
	((struct S3*)s)->two.gamma, \
	((struct S3*)s)->three), string) ;

#define GetStruct_S4(s)	(sprintf(string, "%d %d", \
			((struct S4*)s)->alpha, \
			((struct S4*)s)->beta), string) ;

#define Sizeof_S3()	sizeof(struct S3)

#define Sizeof_U1()	sizeof(union U1)
#define GetUnion_U1_int(s)	((union U1*)s)->integer
#define GetUnion_U1_double(s)	((union U1*)s)->real

#define XS1(a,b)	(++ a->beta, (a->alpha + b))
#define XS2(a,b)	(a.beta += 100, (a.alpha * b))

static struct S1 XS3_struct = {1,2,3.4} ;

#define Addressof_XS3_struct()	((void*)&XS3_struct)

struct S1*
XS3(a,b,c)
int a ;
int b ;
double c ;
{
    XS3_struct.alpha = a ;
    XS3_struct.beta  = b ;
    XS3_struct.gamma  = c ;

    return &XS3_struct ;
}

struct S1
XS4(a,b, c)
int a ;
int b ;
double c ;
{
    struct S1 XS4_struct ;

    XS4_struct.alpha = a ;
    XS4_struct.beta  = b ;
    XS4_struct.gamma  = c ;
 
    return XS4_struct ;
}

MODULE = Harness	PACKAGE = Harness

void
DumpInternalObj(sv)
	SV *	sv

int
Get_a()

void *
Addressof_a()

int
Sizeof_a()


double
Get_b()

void *
Addressof_b()

int
Sizeof_b()

char *
Get_c()

void *
Addressof_c()

int
Sizeof_c()

int
Get_d()

int
Get_e()

int
Get_f()

int
Get_g()

int
Get_h()

int
Get_ii()

char *
GetArray_A1()

int
ReadInt(address)
    void *	address

char *
GetStruct_S1(s)
	void *	s

int
Sizeof_S1()

int
Sizeof_S1_alpha()

int
Sizeof_S1_beta()

int
Sizeof_S1_gamma()

void *
Addressof_s1()

char *
GetStruct_S2(s)
	void *	s

char *
DumpStruct_S2(s)
	void *	s

int
Sizeof_S2()

char *
GetStruct_S3(s)
	void *	s

char *
GetStruct_S4(s)
	void *	s

int
Sizeof_S3()


int
Sizeof_U1()

int
GetUnion_U1_int(s)
	void * s

double
GetUnion_U1_double(s)
	void * s

VAR

int a

double b

char * c

int d
    ACCESS: ro

int e
    ACCESS: wo

int f
    FETCH:
	sv_setiv(ST(0), f * 2) ;

int g
    STORE:
	f = (int)SvIV(ST(1)) - 2 ;

int h
    FETCH:
	sv_setiv(ST(0), h * 10) ;
    STORE:
	h = (int)SvIV(ST(1)) + 5 ;

int ii
    ALIAS: i

TYPE ARRAY

int MyArray1 [sizeof(A1)/sizeof(int)] ;

int A2 [20] ;

int A3 [20] ;
    ACCESS: ro

int A4 [20] ;
    ACCESS: wo

VAR

MyArray1 A1 ;

TYPE HASH

struct S1 {
	int	alpha ;
	short	beta ;
	double	gamma ;
	int	dummy1 ;
	int	dummy2 ;
	} ;
	FETCH:	dummy1
	  sv_setiv(ST(0), var->alpha + var->beta) ;
	ACCESS:	ro dummy1
	STORE:	dummy2
	  var->alpha = (int)SvIV(ST(2)) + 1;
	  var->beta  = (int)SvIV(ST(2)) - 1;
	ACCESS:	wo dummy2


struct S2 
	int	red ;
	struct S1 * blue ;
	short	green ;
	double	yellow ;

struct S3 
	int	one ;
	struct S1  two ;
	short	three ;

struct S4 {
	int	alpha ;
	short	beta ;
	} 
	ADDRESSOF:
	  ST(0) = sv_newmortal();
	  sv_setiv(ST(0), 7654) ;
	SIZEOF:
	  ST(0) = sv_newmortal();
	  sv_setiv(ST(0), 100) ;
	LENGTHOF:
	  ST(0) = sv_newmortal();
	  sv_setiv(ST(0), 2345) ;

union U1
	int	integer ;
	double	real ;


struct tnode 
	char *	word ;
	int	number ;
	char	fixed [10] ;
	int	count ;
	struct tnode *	left ;
	struct tnode *	right ;

VAR

struct S1  s1 ;


XSUB

int
XS1(a,b)
    struct S1 * a
    int b

int
XS2(a,b)
    struct S1	a
    int		b

struct S1 *
XS3(a,b, c)
    int a
    int b
    double c


void *
Addressof_XS3_struct()

struct S1
XS4(a,b,c)
    int a
    int b
    double c
