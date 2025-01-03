# Program Purpose:

# The program accomplishes the following tasks:

#     Generate a Random Integer:
#         Produces a random integer within the range of 1,100,000 to 3,300,000.
#     Reverse the Generated Integer:
#         Extracts the digits of the random integer and reverses their order.
#         For example, if the generated number is 1234567, the reversed number will be 7654321.

.data
	start: .word 1100000
	end: .word 3300000
	newline: .asciiz "\n"
	
.text
	j main
	
	reverse:
		# $a0 -> input
		# $v0 -> output

		# save registers
		subi $sp, $sp, 20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)
		sw $t5, 20($sp)
		
		li $v0, 0 # $v0 -> result
		move $t1, $a0 # current = input
		li $t2, 10 # divisore
		li $t3, 0 # single_digit
		li $t4, 1 # power
		li $t5, 0 # temp
		
		# calculates the highest power
		for1:
			ble $t1, $t2, exit_for_1 # if power <= 10 then exit
			mul $t4, $t4, 10 # power *= 10
			div $t1, $t1, 10 # current /= 10
			j for1
		exit_for_1:
		
		move $t1, $a0 # current = input

		for2:
			beqz $t4, exit_for_2 # if power < 0 then exit
			div $t1, $t2 # current / 10
			mflo $t1 # current /= 10
			mfhi $t3 # single_digit = current % 10
			mul $t3, $t3, $t4 # single_digit = single_digit * temp
			div $t4, $t4, 10 # power /= 10
			add $v0, $v0, $t3 # result += single_digit
			j for2
		exit_for_2:
			# restore registers
			lw $t0, 0($sp)
			lw $t1, 4($sp)
			lw $t2, 8($sp)
			lw $t3, 12($sp)
			lw $t4, 16($sp)
			lw $t5, 20($sp)
			addi $sp, $sp, 20
			jr $ra
	generate_number:
		# $a1 -> start
		# $a2 -> end
		
		# save registers
		subi $sp, $sp, 4
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		
		move $t0, $a1 # start
		move $t1, $a2 # end
		
		sub $t1, $t1, $a1 # end = end - start
		
		li $v0, 42 # syscallid
		li $a0, 1 # par0 seed
		move $a1, $t1 # par1 = end
		syscall # systemcall to generate random int
		
		add $a0, $a0, $t0 # ris = ris + start
		
		# restore registers
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		addi $sp, $sp, 4
		
		jr $ra
	main:
		lw $a1, start
		lw $a2, end
		
		jal generate_number
		jal reverse # reverse $a0
		
		move $a1, $v0 # $a1 = reverse

		# Print input
 		# $a0 is the input
    		li $v0, 1 
    		syscall
    		
		# Print break line
   	 	la $a0, newline    # Load the address of message1 into $a0
    		li $v0, 4           # Syscall code for print string
    		syscall
   
		# Print reversed input
 		move $a0, $a1
    		li $v0, 1 
    		syscall
