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
# Representação das estruturas:
#
# Arvore: Armazena o endereço da raiz e o número de elementos inseridos
#		bytes 	-> descrição
#		[0 - 3] -> endereço da raiz
#		[4 - 7] -> número de elementos na árvore
#
# Bloco: Armazena o elemento e os endereços das sub-árvores da direita e esquerda
#		bytes	 -> descrição
#		[0 - 3]  -> elemento
#		[4 - 7]  -> endereço da sub-árvore da esquerda
#		[8 - 11] -> edereço da sub-árvore da direita

.data
	   	.align 2

elemPrompt:	.asciiz "Digite o novo elemento: "
newLine:	.asciiz "\n"
space:		.asciiz " "
dot:		.asciiz "."
comma:		.asciiz ","
initMenu:	.asciiz "Digite o número correspondente à ação desejada: \n"
opt1:		.asciiz "1) Inserção\n"
opt2:		.asciiz "2) Percorrimento em pré-ordem\n"
opt3:		.asciiz "3) Percorrimento em ordem\n"
opt4:		.asciiz "4) Percorrimento em pós-ordem\n"
opt5:		.asciiz "5) Saída\n"
optWrong:	.asciiz "Entrada inválida! Digite novamente: "
inOrderCall:	.asciiz "Em-ordem\n"
postOrderCall:	.asciiz "Pos-ordem\n"
preOrderCall:	.asciiz "Pre-ordem\n"
emptyTreeError:	.asciiz "Arvore vazia."


.text
main:
	jal createBinaryTree	#Faz um salto para o rótulo de inicialização da árvore binária e armazena o endereço
	la $s1, 0($v0)		#de $ra.Depois, salva o endereço da estrutura de árvore (endereço do primeio nó e o
				#número de elementos) no registrador $s1.
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
	la $a0, ($s1)		# Armazena no registrador $a0 o endereço da árvore binária que estava em $s1.
	jal insert		# Faz um salto para o rótulo de inserção de elementos e salva em $ra o endereço de retorno.
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.
			
OptPreOrder:
	la $a0, ($s1)
	jal preorder		# Faz um salto para o rótulo de percorrimento em pré-ordem e salva em $ra o endereço de retorno.
	
	li $v0, 4		# Imprime uma quebra de linha para formatação da saída.
	la $a0, newLine
	syscall
	
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.

OptInOrder:
	la $a0, ($s1)	
	jal inorder		# Faz um salto para o rótulo de percorrimento em ordem e armazena em $ra o endereço de retorno.

	li $v0, 4		# Imprime uma quebra de linha para formatação da saída.
	la $a0, newLine
	syscall
	
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.

OptPostOrder:
	la $a0, ($s1)
	jal postorder		# Faz um salto para o rótulo de percorrimento em pós-ordem e registra em $ra o endereço de retorno.
	
	li $v0, 4		# Imprime uma quebra de linha para formatação da saída.
	la $a0, newLine
	syscall	
	
	j menu			# Ao final da inserção, faz um salto para o rótulo de menu para retornar às opções.

OptWrong:
	li $v0, 4		# Imprime a string correspondente ao recebimento de uma entrada fora do padrão definido pelo
	la $a0, optWrong	# pelo menu inicial.
	syscall
		
	j menu			# Retorna para o menu inicial.

OptExit:		
	li $v0, 10		# Caso o rótulo de saída seja escolhido, o programa é encerrado.
	syscall

createBinaryTree:		# Este rótulo retorna em $v0 o endereço da árvore binária.
	li $a0, 8		# Armazena em $a0 o número de bytes a serem alocados. 
	li $v0, 9		# Aloca dinamicamente em $v0 o número em bytes armazenado em $a0.
	syscall
	
	sw $zero, 0($v0)	# Inicializa o espaço alocado com o valor zero (primeiro campo).
	sw $zero, 4($v0)	# Inicializa o espaço alocado com o valor zero (segundo campo).
	
	jr $ra			# Retorna para a posição da pilha registrada em $ra.

insert:
	addi $sp, $sp, -4	# Cresce em uma posição o tamanho da pilha para garantir que o endereço esteja live.
	sw $ra, 0($sp)		# Armazena na nova posição de $sp o endereço de retorno $ra.

	la $t2, ($a0)		# Copia para $t2 o endereço da árvore binária que estava em $a0.
	
BTLoop:
	la $a0, elemPrompt	# Impressão de texto para que o usuário digite o elemento a ser inserido na árvore.
	li $v0, 4		
	syscall
	
	li $v0, 5		# Realiza a leitura do número inteiro fornecido pelo usuário e copia essse valor para
	syscall			# o registrador $t0.
	la $t0, ($v0)
	
	beq $t0, 0, BTEnd	# Compara se a entrada do usuário registrada em $t0 é igual ao número 0, o qual é
				# definido como o valor de saída do modo de inserção.
				
	la $t3, ($t2)		# Copia para o registrador $t3 o endereço do nó de raiz (ou do nó atual).
	
BTFind:				# Rótulo de loop para inserção do elemento na posição correta

	lw $t1, 0($t3)		# Salva o elemento atual em $t1.
	beq $t1, $zero, BTAdd	# Caso o elemento atual possua valor igual a zero, uma folha foi encontrada. Dessa forma,
				# basta adicionar o elemento na árvore, mudando para o rótulo de adição.
	
	la $t3, ($t1)		# Caso a posição atual não seja uma folha, copia para $t3 a posição do elemento atual.
	
	lw $t1, 0($t3)		# Retorna a $t3 o valor do elemento atual.
	blt $t0, $t1, BTLess	# Se o valor inserido pelo usuário for menor do que o valor do elemento atual, faz um 
				# desvio para o rótulo BTLess.
	
	addi $t3, $t3, 8	# Do contrário, designa a busca para a sub árvore da direita.
	j BTFind		# Salto para continuar a busca pela posição de inserção.

BTLess:
	addi $t3, $t3, 4	# Designa o ponteiro do bloco atual para a sub árvore da esquerda.
	j BTFind		# Salto para continuar a busca pela posição de inserção.
	
BTAdd:
	li $a0, 12		# Armazena em $a0 o número de bytes que correspondem a um bloco.
	li $v0, 9		# Realiza a alocação em $v0 conforme o valor armazenado em  $a0.  
	syscall
	
	sw $v0, 0($t3)		# Armazena no endereço desejado o novo bloco.

	sw $t0, 0($v0)		# Armazena o valor do elemento inserido pelo usuário no novo bloco.
	
	sw $zero, 4($v0)	# Inicializa como zero o endereço da sub árvore à esquerda do novo nó.
	sw $zero, 8($v0)	# Inicializa como zero o endereço da sub árvore à direita do novo nó.
	
	lw $t4, 4($t2)		# Armazena em $t4 o número de elementos da árvore binária antes da inserção.
	addi $t4, $t4, 1	# Incrementa o número de elementos da árvore binária.
	
	sw $t4, 4($t2)		# Retorna para a estrutura o número de elementos atualizado.
	
	j BTLoop		# Faz um salto para o rótulo de loop da inserção.
	
BTEnd:
	la $v0, ($t2)		# Copia o valor de retorno de $t2 para o registrador de saída $v0.

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# $a0 : tree address
preorder:
	la $t0, ($a0)

	la $a0, preOrderCall
	li $v0, 4
	syscall
	
	lw $a0, 0($t0)

	bne $a0, $zero, preOrderRun
	
	la $a0, emptyTreeError
	li $v0, 4
	syscall
	
	jr $ra
preOrderRun:
	lw $a1, 4($t0)
	lw $a0, 0($t0)
preOrderLoop:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beqz $a0, PreEnd
	
	la $s0, ($a0)

	la $a0, 0($s0)
	addi $a1, $a1, -1
	jal print_elem

	lw $a0, 4($s0)	# address of the left tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal preOrderLoop
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	lw $a0, 8($s0)	# address of the right tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal preOrderLoop
	lw $s0, 0($sp)
	addi $sp, $sp, 4
PreEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# $a0 : tree address
postorder:
	la $t0, ($a0)

	la $a0, postOrderCall
	li $v0, 4
	syscall
	
	lw $a0, 0($t0)

	bne $a0, $zero, postOrderRun
	
	la $a0, emptyTreeError
	li $v0, 4
	syscall
	
	jr $ra
postOrderRun:
	lw $a1, 4($t0)
	lw $a0, 0($t0)
postOrderLoop:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beqz $a0, POEnd
	
	la $s0, ($a0)

	lw $a0, 4($s0)	# address of the left tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal postOrderLoop
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	lw $a0, 8($s0)	# address of the right tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal postOrderLoop
	lw $s0, 0($sp)
	addi $sp, $sp, 4

	la $a0, 0($s0)
	addi $a1, $a1, -1
	jal print_elem
	
POEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# $a0 : tree address
inorder:
	la $t0, ($a0)

	la $a0, inOrderCall
	li $v0, 4
	syscall
	
	lw $a0, 0($t0)

	bne $a0, $zero, inOrderRun
	
	la $a0, emptyTreeError
	li $v0, 4
	syscall
	
	jr $ra
inOrderRun:
	lw $a1, 4($t0)
	lw $a0, 0($t0)
inOrderLoop:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	beqz $a0, InEnd
	
	la $s0, ($a0)

	lw $a0, 4($s0)	# address of the left tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal inOrderLoop
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	la $a0, 0($s0)
	addi $a1, $a1, -1
	jal print_elem
	
	lw $a0, 8($s0)	# address of the right tree
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	jal inOrderLoop
	lw $s0, 0($sp)
	addi $sp, $sp, 4

InEnd:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# $a0 : elem
# $a1 : elem_num
print_elem:
	li $v0, 1
	lw $a0, 0($a0)
	syscall
	
	beqz $a1, print_dot
	la $a0, comma
	j print_delimiter
print_dot:
	la $a0, dot
print_delimiter:
	li $v0, 4
	syscall

	jr $ra
