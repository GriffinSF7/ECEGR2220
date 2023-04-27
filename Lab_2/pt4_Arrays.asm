#Lab 2
#Part 3
.data
	
	arrayA: .word 0, 0, 0, 0, 0
	arrayB: .word 1, 2, 4, 8, 16
.text

main:
	la	t0, arrayA
	la	t1, arrayB
	add	s1, x0, x0 # i = 0
	addi	t2, x0, 5 #t2 = 5
	jal 	loop
	
	li	a7, 10
	ecall

loop:
	bge	s1, t2, sub_i # if i >= 5, branch to while
	slli	t3, s1, 2 # t3 = i*4
	add	t4, t3, t1 # t4 = B + offset address
	lw	s2, 0(t4) #s2 = B[i] value
	addi	s2, s2, -1 # s2 = B[i] - 1
	add	t4, t3, t0 #t4 = A[i] address
	sw	s2, 0(t4) #A[i] = B[i] - 1	
	addi	s1, s1, 1 # i++
	j loop #loop

sub_i:
	addi 	s1, s1, -1 # i--
while:
	blt	s1, x0, return # if i < 0, branch to return
	slli	t3, s1, 2 # t3 = i*4
	add	t4, t3, t1 # t4 = B + offset address
	lw	s2, 0(t4) #s2 = B[i] value
	add	t4, t3, t0 #t4 = A[i] address
	lw	s3, 0(t4) #s3 = A[i] value
	add	s3, s3, s2 # s3 = A[i] + B[i]
	slli	s3, s3, 1 # A[i] = s3 * 2
	sw	s3, 0(t4)
	addi 	s1, s1, -1 # i--
	j while #loop
	
return:
	ret
