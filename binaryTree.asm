# Tree:
#	[0 - 3] -> address
#	[4 - 7] -> number of nodes
# Block:
#	[0 - 3] -> elem
#	[4 - 7] -> left tree
#	[8 - 12] -> right tree

.data
	   	.align 2
blocksize: 	.word 12
elemPrompt:	.asciiz "Digite o novo elemento: "
newLine:	.asciiz "\n"

.text
main:
	jal createBinaryTree
	
	lw $s1, 0($v0)
	la $a0, ($s1)
	jal postorder
	
	li $v0, 4
	la $a0, newLine
	syscall	
	
	la $a0, ($s1)
	jal preorder
	
	li $v0, 4
	la $a0, newLine
	syscall

	la $a0, ($s1)
	jal inorder

	li $v0, 10	# exit
	syscall

# return $v0 tree address
createBinaryTree:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $a0, 8
	li $v0, 9
	syscall
	
	la $t2, ($v0)		# get tree address
	sw $zero, 0($t2)	# tree address
	sw $zero, 4($t2)	# set number of elements to zero
BTLoop:
	la $a0, elemPrompt	# prompt the user to include a new element
	li $v0, 4		# print_string call
	syscall
	
	li $v0, 5		# read_int call
	syscall
	
	la $t0, ($v0)		# input elem, $t0 = $v0
	
	beq $t0, 0, BTEnd	# if equal to the end input, return tree address
	
	la $t3, ($t2)		# address of root (or current block)
BTFind:
	lw $t1, 0($t3)		# current adress
	beq $t1, $zero, BTAdd	# if encounter a leaf, add element
	
	la $t3, ($t1)
	
	lw $t1, 0($t3)		# current element
	blt $t0, $t1, BTLess	# if $t0 < $t1 goto BTLess
	
	addi $t3, $t3, 8	# set the current block to the right tree
	j BTFind

BTLess:
	addi $t3, $t3, 4	# set the current block to the left tree
	j BTFind
BTAdd:
	li $a0, 12		# set to get 12bytes from heap
	li $v0, 9		# sbrk call
	syscall
	
	sw $v0, 0($t3)		# new block address

	sw $t0, 0($v0)		# store the element in the block
	
	sw $zero, 4($v0)	# set the address of the left tree to invalid
	sw $zero, 8($v0)	# set the address of the right tree to invalid
	
	lw $t4, 4($t2)
	addi $t4, $t4, 1
	
	sw $t4, 4($t2)
	
	j BTLoop
BTEnd:
	la $v0, ($t2)		# set the return register to the address

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# $a0 : tree address
preorder:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beqz $a0, PreEnd
	
	la $s0, ($a0)

	li $v0, 1
	lw $a0, 0($s0)
	syscall	
	
	li $v0, 4
	la $a0, newLine
	syscall

	lw $a0, 4($s0)	# address of the left tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal preorder
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	lw $a0, 8($s0)	# address of the right tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal preorder
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
PreEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# $a0 : tree address
postorder:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beqz $a0, POEnd
	
	la $s0, ($a0)

	lw $a0, 4($s0)	# address of the left tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal postorder
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	lw $a0, 8($s0)	# address of the right tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal postorder
	lw $s0, 0($sp)
	addi $sp, $sp, 4

	li $v0, 1
	lw $a0, 0($s0)
	syscall	
	
	li $v0, 4
	la $a0, newLine
	syscall
	
POEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# $a0 : tree address
inorder:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beqz $a0, InEnd
	
	la $s0, ($a0)

	lw $a0, 4($s0)	# address of the left tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal inorder
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	li $v0, 1
	lw $a0, 0($s0)
	syscall	
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	lw $a0, 8($s0)	# address of the right tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal inorder
	lw $s0, 0($sp)
	addi $sp, $sp, 4

InEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
