#Lab 2
#Part 3
.data
	
	int_a: .word 0
	int_b: .word 0
	int_c: .word 0
.text

main:
	
	addi	t0, x0, 5	#i = 5
	addi	t1, x0, 10	#j = 10
	
	addi	sp, sp, -12	#adjust stack for 3 elements
	sw	ra, 8(sp)
	sw	t0, 4(sp)	#save i into stack
	sw	t1, 0(sp)	#save j into stack
	add	t2, x0, t0	# i => n
	jal 	AddItUp		#call AddItUP function
	sw	t1, int_a, t3	#save return value to a
	lw	ra, 8(sp)
	lw	t0, 4(sp)
	lw	t1, 0(sp)
	addi	sp, sp, 12
	
	addi	sp, sp, -12	#adjust stack for 3 elements
	sw	ra, 8(sp)
	sw	t0, 4(sp)	#save i into stack
	sw	t1, 0(sp)	#save j into stack
	add	t2, x0, t1	# j => n
	jal	AddItUp	
	sw	t1, int_b, t3	#save return value to b
	lw	ra, 8(sp)
	lw	t0, 4(sp)	#save i into stack
	lw	t1, 0(sp)
	addi	sp, sp, 12
	
	lw	t0, int_a
	lw	t1, int_b
	add	t0, t0, t1	# c = a + b
	sw	t0, int_c, t3	
	
	li	a7, 10
	ecall

AddItUp:
	
	add	t0, x0, x0	# i=0
	add	t1, x0, x0	# x=0
	j loop
	
loop:
	bge	t0, t2, return	#if i >= n, branch to 0
	addi	t0, t0, 1	#i++
	addi	t3, t0, 1	#t3 = i+1
	add	t1, t1, t3	#x = x + i + 1
	j loop
return:
	ret