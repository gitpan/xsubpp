package Harness ;

use Exporter;
use AutoLoader;
use DynaLoader ;

@ISA = (Exporter, AutoLoader, DynaLoader);

@EXPORT = qw ( 

	DumpInternalObj

	$a	Get_a Addressof_a Sizeof_a
	$b	Get_b Addressof_b Sizeof_b
	$c	Get_c Addressof_c Sizeof_c
	$d	Get_d
	$e	Get_e
	$f	Get_f
	$g	Get_g
	$h	Get_h
	$i	Get_ii

	ReadInt
	$A1	GetArray_A1 

	GetStruct_S1 Sizeof_S1 Sizeof_S1_alpha Sizeof_S1_beta Sizeof_S1_gamma 
	$s1	Addressof_s1

	DumpStruct_S2 GetStruct_S2 Sizeof_S2 
	GetStruct_S3 Sizeof_S3 

	GetUnion_U1_int GetUnion_U1_double  Sizeof_U1

	XS1 XS2 XS3 XS4
	Addressof_XS3_struct
	) ;


bootstrap Harness ;


# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

1;
__END__
