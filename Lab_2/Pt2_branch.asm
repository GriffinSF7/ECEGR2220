#Lab 2
#Part 1
.data
	A: .word 15
	B: .word 15
	C: .word 10
	Z: .word 0
	str: .asciz "value of Z = "
.text

main:
	la	t0, Z
	lw	s1, 0(t0)
	la	t0, A
	lw	s2, 0(t0)
	la	t0, B
	lw	s3, 0(t0)
	la	t0, C
	lw	s4, 0(t0)	# read and load A,B,C,Z from memory to registers
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
	bge	s3, s2, else_2 #if B >= A, branch to else_2
	addi	t2, s3, 1 #get C+1
	addi	t3, t3, 7 #set t3 = 7
	bne	t2, t3, else_2 #if C+1 != 7, branch to else_2
	addi	s1, s1, 2 #set Z = 2
	j switch_Z
else_2:
	addi	s1, s1, 3 #set Z = 3
	
switch_Z:
	addi	t4, t4, -1
	addi	t5, t5, -2
	addi	t6, t6, -3
	beq	s1, t4, break #case 1
	beq	s1, t5, break #case 2
	beq	s1, t6, break #case 3
	beqz	s1, break	#default
break:
	ret