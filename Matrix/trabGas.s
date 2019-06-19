# X=(Tamanho da matriz * Linha) + Coluna

	.section .data

.equ	 tam,		5
soma:	.int		0
aux:	.int		0
menor:	.int		0


# contadores
i: .int			0
j: .int			0
k: .int	 		0

	.section .text

.extern printf

.globl C_Gas
C_Gas:

        pushl    %ebp
        movl     %esp,%ebp
        movl     8(%ebp),%esi    			# Aponta matriz A
        movl     12(%ebp),%edi   			# Aponta matriz B
	movl	 16(%ebp),%ebx   			# Aponta matriz auxiliar


#(A+B) E (2*B)--------------------------------------------------------------------------- 

	movl	$tam,i
for1:
	decl	i
	movl	$tam,j

	for2:
		decl	j
		movl	$tam,%eax
		movl	i,%edx
		mull	%edx 				# Multiplica tamanho da matriz pela linha
		addl	j,%eax 				# Soma coluna
		sall	$2,%eax 			# Multiplica por 4
		movl	%eax,%ecx 			# Ecx controla a posição no vetor

		# Carrega os valores para os registradores e faz a soma
		movl	(%esi,%ecx),%eax
		movl	(%edi,%ecx),%edx
		addl	%edx,%eax 			# Soma as matrizes (A+B)
		movl	%eax,(%ebx,%ecx)		# Guarda na matriz(vetor) auxiliar

		addl	%edx,%edx	 		# (2B)
		movl	%edx,(%edi,%ecx) 		# Substitui o elemento X para 2X


	cmpl	$0,j
	jne	for2

	cmpl	$0,i
	jne	for1

#(A+B * 2B)------------------------------------------------------------------------------

	xorl	%esi,%esi
	movl    $tam,i
forF1:
        decl    i
        movl    $tam,j

       forF2:
                decl    j
                movl    $0,soma
                movl    $tam,k

                forF3:
            	        decl    k
            	        movl    $tam,%eax
                   	movl    i,%edx
                    	mull    %edx			# Multiplica tamanho da matriz pela linha
                    	addl    k,%eax			# Soma coluna
                    	sall    $2,%eax			# Multiplica por 4
                    	movl    %eax,%ecx		# Ecx controla a posição no vetor

                    	movl     $tam,%eax
                    	movl     k,%edx
                    	mull     %edx			# Multiplica tamanho da matriz pela linha
                    	addl     j,%eax			# Soma coluna
                    	sall     $2,%eax		# Multiplica por 4
                    	movl     %eax,%esi		# Esi controla a posição no vetor

                    	movl     (%ebx,%ecx),%eax	# Eax pega valor de (A+B)
                    	movl     (%edi,%esi),%edx	# Edx pega valor de 2B
                    	mull     %edx

                    	addl    %eax,soma		# Salva valor da multiplicação na soma parcial
                    	cmpl    $0,k
                    	jne     forF3
		    	pushl   soma			# Salva a soma final do elemento na pilha

                cmpl    $0,j
                jne     forF2

	cmpl    $0,i
        jne     forF1


#(Menor elemento da diagonal principal)--------------------------------------------------

	movl	(%esp),%ecx				# Ecx recebe primeiro elemento da matriz final (que está no topo da pilha)
	movl	%ecx,menor				# Primeiro elemento da matriz final inicia-se como o menor
	movl	$tam,i

Cond_Busca:
	decl	i
	movl    $tam,%eax
      	movl    i,%edx
        mull    %edx					# Multiplica tamanho da matriz pela linha
	addl	i,%eax					# Soma linha (apenas elementos da diagonal principal são validos)
	sall	$2,%eax					# Multiplica por 4
	movl	%eax,%edx				# Edx controla posição no vetor

	movl	(%esp,%edx),%ebx			# Ebx recebe o elemento atual
	cmpl	menor,%ebx				# Compara com o menor
	jl	Troca
	cmpl	$0,i
	jne	Cond_Busca
	jmp	Fim

Troca:
	movl	%ebx,menor
	cmpl	$0,i
	jne	Cond_Busca


Fim: 
	movl	menor,%eax				# Retorna menor elemento da diagonal principal
	movl 	%ebp,%esp
	popl 	%ebp
	ret
