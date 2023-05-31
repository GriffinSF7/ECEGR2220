# UNTITLED PROGRAM

	.data		# Data declaration section

	.text

main:			# Start of code section
	addi t0, zero, 13
	addi t1, zero, 15
	andi t0, t1, 5
	li a7, 1	# system call code for print_int
	li a0, 26	# integer to print
	ecall		# print it
	
# END OF PROGRAM
