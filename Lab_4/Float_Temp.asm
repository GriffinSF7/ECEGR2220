.data

C_FVal1:	.float 32.0
C_FVal2:	.float 5.0
C_FVal3:	.float 9.0
Fahrenheit:	.asciz	"Enter temperature in Fahrenheit: "
Celcius:	.asciz  "Converting to Celcius: "
Kelvin:		.asciz	"Converting to Kelvin: "


.text
.globl	floats

main:
	flw	ft5, C_FVal1, t0	#load FP val from memory
	flw	ft6, C_FVal2, t0
	flw	ft7, C_FVal3, t0
	
	li	a7,4		#print string
	la	a0, Fahrenheit
	ecall
	li	a7,6			#reading fp
	ecall
	
	fmv.s	ft1, fa0		#save result in ft1
	 
	fsub.s	ft1, ft1, ft5  
	fmul.s	ft1, ft1, ft6
	fdiv.s	ft1, ft1, ft7
	
	li	a7, 4			#system call for print string
	la	a0, Celcius
	ecall
	li	a7, 2			#system call for printing float fa0
	ecall

	fmv.s	ft2,fa0		#save result in ft2

	fmul.s	ft3, ft1, ft2	# mult fp numbers
	fmul.s	ft3, ft3, ft0	# mult fp numbers

	fmv.s	fa0, ft3	# copy FP value from ft3 to fa0
	fmv.x.s	t1, ft3		# copy FP value to t reg

	fsw	fa0, fpVal, t0	#store FP val to memory
	

	