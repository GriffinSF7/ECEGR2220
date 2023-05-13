#Lab 2
#Part 3
.data

	Z: .word 2
	i: .word 0
.text

main:
	lw	s1, Z
	lw	s2, i
	add	s2, x0, x0 # i = 0
	addi	t2, t2, 20 #t2 = 20
	jal 	loop
	sw	s1, Z, t0 
	sw	s2, i, t1
	
	li	a7, 10
	ecall

loop:
	blt	t2, s2, do # if i > 20, branch to do
	addi	s2, s2, 2 # i = i + 2
	addi	s1, s1, 1 # Z++
	j loop #loop

do:
	addi	t3, x0, 100
	bge	s1, t3, while # if Z >= 100, branch to while 
	addi	s1, s1, 1  # Z++
	j do #loop
	
while:
	slt	t3, x0, s2 # if i > 0, t3 = 1
	sub	s1, s1, t3 # Z = Z - t3
	sub	s2, s2, t3 # i = i - t3
	beq	t3, x0, return # if t3 = 0, i <= 0, branch to return 
	j while #loop
	
return:
	ret
