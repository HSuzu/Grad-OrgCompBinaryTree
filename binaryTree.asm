# Código desenvolvido para o primeiro trabalho da disciplina SSC0610 - Organização de Computadores Digitais I
# da Universidade de São Paulo campus São Carlos.
#
# Docente: Prof. Dr. Francisco José Monaco
# Monitor PEEG: Vitor P. Ribeiro
# Monitor: Guilherme Prearo
#
# Alunos: Augusto Ribeiro Casto - 9771421
#	  Gabriel Santos Ribeiro - 9771380
#	  Henry Shinji Suzukawa - 9771504
#	  Túlio Fernandes Rickli Costa - 9771491
#
# 	Este código ilustra a representação de uma árvore binária ordenada em Assembly MIPS. Dentro do trabalho 
# existem algoritmos que permitem a inserção de números inteiros na estrutura, o percorrimento desta em ordem,
# em pré-ordem e em pós-ordem. A estrutura implementada é alocada dinamicamente e, por definição acordada com 
# o monitor PEEG, não aceita a inserção do número inteiro zero (0), pois esse valor é utilizador para que o
# usuário saia da opção de inserção e retorne ao menu inicial.
#
# Lixo?
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
space:		.asciiz " "
initMenu:	.asciiz "Digite o número correspondente à ação desejada: \n"
opt1:		.asciiz "1) Inserção\n"
opt2:		.asciiz "2) Percorrimento em pré-ordem\n"
opt3:		.asciiz "3) Percorrimento em ordem\n"
opt4:		.asciiz "4) Percorrimento em pós-ordem\n"
opt5:		.asciiz "5) Saída\n"
optWrong:	.asciiz "Entrada inválida! Digite novamente: "


.text
main:
menu:
	li $v0, 4		#Impressão de quebra de linha na tela para formatação.
	la $a0, newLine
	syscall

	li $v0, 4		#Impressão da string de comando do menu.
	la $a0, initMenu
	syscall
	
	li $v0, 4		#Impressão da string de opção de comando correspondente à inserção.
	la $a0, opt1
	syscall

	li $v0, 4		#Impressão da string de opção de comando correspondente à busca em pré-ordem.
	la $a0, opt2
	syscall	
		
	li $v0, 4		#Impressão da string de opção de comando correspondente à busca em ordem.
	la $a0, opt3
	syscall			

	li $v0, 4		#Impressão da string de opção de comando correspondente à busca em pró-ordem.
	la $a0, opt4
	syscall			

	li $v0, 4		#Impressão da string de opção de comando correspondente à opção de saída do programa.
	la $a0, opt5
	syscall		
	
	li $v0, 5		#Recebe um inteiro inserido pelo usuário e armazena no registrador $t5.
	syscall
	move $t5, $v0
	
	beq $t5, 1, OptInsert	# Compara o inteiro armazenado em $t5 com os valores dados como opção pelo menu, de
	beq $t5, 2, OptPreOrder # modo a fazer um desvio em caso de igualdade com um dos valores possíveis para o 
	beq $t5, 3, OptInOrder  # rótulo correspondente.
	beq $t5, 4, OptPostOrder
	beq $t5, 5, OptExit
	j OptWrong		# Caso nenhuma das condições anteriores seja satisfeita, a entrada dada não está de
				# acordo com o padrão fornecido pelo menu. Dessa forma,é feito um jump para o rótulo
				# que representa uma entrada "errada" e o usuário é levado novamente ao menu.

OptInsert:
	jal createBinaryTree	# Faz um salto para o rótulo de inserção de elementos e salva em $ra o endereço de retorno.
	lw $s1, 0($v0)		# Nun sei
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.
			
OptPreOrder:			
	la $a0, ($s1)		# Armazena em $a0 o conteúdo do registrador $s1 para NÂO SEI
	jal preorder		# Faz um salto para o rótulo de percorrimento em pré-ordem e salva em $ra o endereço de retorno.
	
	li $v0, 4		# Imprime uma quebra de linha para formatação da saída.
	la $a0, newLine
	syscall
	
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.

OptInOrder:
	la $a0, ($s1)		# Armazena em $a0 o conteúdo do registrador $s1 para NÂO SEI
	jal inorder		# Faz um salto para o rótulo de percorrimento em ordem e armazena em $ra o endereço de retorno.

	li $v0, 4		# Imprime uma quebra de linha para formatação da saída.
	la $a0, newLine
	syscall
	
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.

OptPostOrder:																																																				
	la $a0, ($s1)		# Armazena em $a0 o conteúdo do registrador $s1 para NÂO SEI.
	jal postorder		# Faz um salto para o rótulo de percorrimento em pós-ordem e registra em $ra o endereço de retorno.
	
	li $v0, 4		# Imprime uma quebra de linha para formatação da saída.
	la $a0, newLine
	syscall	
	
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.

OptWrong:
	#Text printing
	li $v0, 4		# Imprime a string correspondente ao recebimento de uma entrada fora do padrão definido pelo
	la $a0, optWrong	# pelo menu inicial.
	syscall
		
	j menu			# Retorna para o menu inicial.

OptExit:		
	li $v0, 10		# Caso o rótulo de saída seja escolhido, o programa é encerrado.
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
	la $a0, space
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
	la $a0, space
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
	la $a0, space
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
