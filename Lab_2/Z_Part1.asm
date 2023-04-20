#Lab 2
#Part 1
.data

	Z: .word 0
	str: .asciz "value of Z ="
.text

main:
	la	t0, Z
	lw	s1, 0(t0)
	jal 	arith_op
	sw	s1, Z, t0
	
	li	a7, 4		
	la	a0, str
	ecall

	li	a7, 1		
	lw	a0, Z
	ecall
	
	li	a7, 10
	ecall

arith_op:
	addi t1, t1, 15 #A
	addi t2, t2, 10	#B
	addi t3, t3, 5  #C
	addi t4, t4, 2	#D
	addi t5, t5, 18	#E
	addi t6, t6, -3	#F
	sub  s1, t1, t2	# A-B
	mul  t0, t3, t4	# C*D
	add  s1, s1, t0 #(A-B)+(C*D)
	sub  t0, t5, t6 # E-F
	add  s1, s1, t0	# (A-B)+(C*D)+(E-F)
	div  t0, t1, t3 # A/C
	sub  s1, s1, t0	#(A-B)+(C*D)+(E-F)-(A/C)
	ret
