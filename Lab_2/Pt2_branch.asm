#Lab 2
#Part 1
.data
	A: .word 15
	B: .word 15
	C: .word 6
	Z: .word 0
	str: .asciz "value of Z = "
.text

main:
	lw	s1, Z
	lw	s2, A
	lw	s3, B
	lw	s4, C	# read and load A,B,C,Z from memory to registers
	jal	condition
	sw	s1, Z, t0	#store register value to memory variable	
	sw	s2, A, t0
	sw	s3, B, t0
	sw	s4, C, t0	
	li	a7, 4		#print value of Z
	la	a0, str
	ecall

	li	a7, 1		
	lw	a0, Z
	ecall
	
	li	a7, 10
	ecall

condition:
	slt	t0, s2, s3 #if A < B, t0 = 1
	slti	t1, s3, 5 # if C < 5, t1 = 1, opposite of C > 5
	beq	t0, t1, else_1 # t0 == t1, branch to else. t0 != t1, continue
	addi	s1, s1, 1
	j switch_Z
else_1:
	blt	s3, s2, else_1.1 #if A > B, branch to else_1.1
	addi	t2, s4, 1 #get C+1
	addi	t3, x0, 7 #set t3 = 7
	beq	t2, t3, else_1.1   #if C+1 = 7, branch to else_1.1
	j else_2
else_1.1:	
	addi	s1, s1, 2 #set Z = 2
	j switch_Z
else_2:
	addi	s1, s1, 3 #set Z = 3
	
switch_Z:
	addi	t4, x0, -1
	addi	t5, x0, -2
	addi	t6, x0, -3
	beq	s1, t4, break #case 1
	beq	s1, t5, break #case 2
	beq	s1, t6, break #case 3
	beqz	s1, break	#default
break:
	ret
