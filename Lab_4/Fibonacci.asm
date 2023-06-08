#Lab 4
#Part 2
.data
	
	a_int: .word 0
	b_int: .word 0
	c_int: .word 0
.text

main:
	lw	t3, a_int
	lw	t4, b_int
	lw	t5, c_int
	
	addi	sp, sp, -8	#adjust stack for 1 elements
	sw	ra, 4(sp)
	sw	t0, 0(sp)	#save a into stack
	addi	t0, x0, 3	#t0 = 3
	jal 	Fibonacci	#call Fibonacci function
	sw	a0, a_int, t3	#save return value to a
	lw	ra, 4(sp)
	lw	t0, 0(sp)
	addi	sp, sp, 8
	
	addi	sp, sp, -8	#adjust stack for 1 elements
	sw	ra, 4(sp)
	sw	t0, 0(sp)	#save b into stack
	addi	t0, x0, 10	#t0 = 10
	jal 	Fibonacci		
	sw	a0, b_int, t3	#save return value to a
	lw	ra, 4(sp)
	lw	t0, 0(sp)
	addi	sp, sp, 8
	
	addi	sp, sp, -8	#adjust stack for 1 elements
	sw	ra, 4(sp)
	sw	t0, 0(sp)	#save c into stack
	addi	t0, x0, 20	#t0 = 20
	jal 	Fibonacci	
	sw	a0, c_int, t3	#save return value to a
	lw	ra, 4(sp)
	lw	t0, 0(sp)
	addi	sp, sp, 8
		
	sw	t3, a_int, t1
	sw	t4, b_int, t1
	sw	t5, c_int, t1

	li	a7, 10
	ecall

Fibonacci:
	blt	zero, t0, elseif	#if n > 0, branch to elseif
	addi	t1, zero, 0
	j return
	
elseif:
	addi	t2, zero, 1
	bne	t0, t2, else	#if n not= 1, branch to else
	addi	a0, zero, 1
	j return

else:
	addi	sp, sp, -8	#adjust stack for 1 elements
	sw	ra, 4(sp)
	sw	a0, 0(sp)	#save a into stack
	addi	t0, t0, -1	# n = n-1
	jal	Fibonacci
	lw	a0, 0(sp)
	add	a0, a0, t1
	sw	a0, 0(sp)
	addi	t0, t0, -2	# n = n-2
	jal	Fibonacci
	lw	ra, 4(sp)
	lw	a0, 0(sp)
	add	a0, a0, t1
	sw	a0, 0(sp)
	addi	sp, sp, 8	 
	ret
	
return:
	ret
