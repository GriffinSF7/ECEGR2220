.data

F_CVal1:	.float 32.0
F_CVal2:	.float 5.0
F_CVal3:	.float 9.0
C_KVal1:	.float 273.15
C_data:		.float 0.0
K_data:		.float 0.0
Fahrenheit:	.asciz	"Enter temperature in Fahrenheit: "
Celcius:	.asciz  "Converting to Celcius: "
Kelvin:		.asciz	"Converting to Kelvin: "
newln:		.asciz	"\r\n"

.text
.globl	conversion

main:
	flw	ft5, F_CVal1, t0	#load FP val from memory
	flw	ft6, F_CVal2, t0
	flw	ft7, F_CVal3, t0
	flw	ft8, C_KVal1, t0
	
	li	a7,4		#print string
	la	a0, Fahrenheit
	ecall
	li	a7,6			#reading fp
	ecall
	
	fmv.s	ft1, fa0		#save result in ft1
	jal conversion
	
	fmv.s	fa0, ft1
	li	a7, 4			#system call for print string
	la	a0, Celcius
	ecall
	li	a7, 2			#system call for printing float fa0
	ecall
	li	a7,4			#system call for print string
	la	a0,newln
	ecall

	fmv.s	fa0, ft2
	li	a7, 4			#system call for print string
	la	a0, Kelvin
	ecall
	li	a7, 2			#system call for printing float fa0
	ecall
	li	a7,4			#system call for print string
	la	a0,newln
	ecall
	
	li	a7, 10
	ecall
	
conversion:
	fsub.s	ft1, ft1, ft5  		# subtract Farenheit degree by 32.0
	fmul.s	ft1, ft1, ft6		# multiplied by 5.0
	fdiv.s	ft1, ft1, ft7		# then divided by 9.0 to obtain Celcius degree
	fsw	ft1, C_data, t0		#store Celcius data to memory
	fadd.s	ft2, ft1, ft8		#add 273.15 to Celcius
	fsw	ft2, K_data, t0 	# store Kelvin data to memory
	
	ret
