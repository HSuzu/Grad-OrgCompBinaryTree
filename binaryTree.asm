.data
	.align 2

.text

main:


createBinaryTree:


# $a0 : tree address
# $a1 : vector size
preorder:
	addi $sp, $sp, -4	# prepare to add a new element on stack
	sw $ra, 0($sp)		# add the return adress on stack

	lw $t2, 0($a0)

	sw $zero, 0($t0)	# initiates $t0 = 0
				# $t0 will point to the next element
	sw $zero, 0($t1)	# initiates $t1 = 0
				# $t1 will point to the current element
	
preorderLoop:
	bge $t1, $a1, preorderRetrieve	# if the pointer of the current element
					# is pointing to outside of the vector
					# jump to Retrieve
	
	add $t0, $t1, $t1	# $t0 = 2*$t1

	addi $t0, $t0, 1	# $t0 = 2*$t1 + 1

	addi $sp, $sp, -4	# prepare to store the current element
	sw $t1, 0($sp)		# and store it

	addi $sp, $sp, -4	# prepare to store the next element
	sw $t0, 0($sp)		# and store it

	jal preorderLoop
	
	add $t3, $t2, $t1
	lw $a0, 0($t3)
	
	li $v0, 1
	syscall
	
	addi $sp, $sp, -4	# prepare to store the current element
	sw $t1, 0($sp)		# and store it

	addi $t0, $t0, 1	# $t0 = $t0 + 1
	addi $sp, $sp, -4

	sw $t0, 0($sp)
	jal preorderLoop
	
preorderRetrieve:
	addi $sp, $sp, 4
	sw $sp, 0($ra)
	
	addi $sp, $sp, 4
	sw $sp, 0($t0)

	addi $sp, $sp, 4
	sw $sp, 0($t1)
		
	jr $ra
