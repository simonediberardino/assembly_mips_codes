# Assembly MIPS Code to calculate the N fibonacci number.
# Output is saved in the $v0 register.

.data 
	input: .word 5
.text
	j main
	
	fib:
		# ris = fib(n-1) + fib(n-2)
		# a0 -> n

		# save registers
		subi $sp, $sp, 16
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $ra, 12($sp)
		sw $a0, 16($sp)
				
		li $t0, 0
		li $t0, 0
		li $t1, 0 # first result
		li $t2, 0 # second result
		ble $a0, 1, base_case
		
		subi $a0, $a0, 1 # $n - 1
		# 1° recursive call
		jal fib
		move $t1, $v0 # first result
		
		subi $a0, $a0, 1 # $n - 2
		# 2° recursive call
		jal fib
		move $t2, $v0 # second result
		
		add $v0, $t1, $t2 # result = first result + second result
		j end_fib
	base_case:
		li $v0, 1
		j end_fib
	end_fib:
		# reset registers
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $ra, 12($sp)
		lw $a0, 16($sp)

		addi $sp, $sp, 16
		jr $ra
	main:
		lw $a0, input
		jal fib
	end_main:
