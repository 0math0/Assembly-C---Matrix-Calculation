; X=(Tamanho da matriz * Linha) + Coluna

	SECTION .data

tam:	EQU	5
soma:	dd	0
aux:	dd	0
menor:	dd	0


; contadores
i: dd 0
j: dd 0
k: dd 0

	SECTION .text

extern printf

global C_Asm
C_Asm:

        push    ebp
        mov     ebp,esp
        mov     esi,[ebp+8]    			; Aponta matriz A
        mov     edi,[ebp+12]   			; Aponta matriz B
	mov	ebx,[ebp+16]   			; Aponta matriz auxiliar


;(A+B) E (2*B)--------------------------------------------------------------------------- 

	mov	DWORD [i],tam
for1:
	dec	DWORD [i]
	mov	DWORD [j],tam

	for2:
		dec	DWORD [j]
		mov	eax,tam
		mov	edx,[i]
		mul	edx 			; Multiplica tamanho da matriz pela linha
		add	eax,[j] 		; Soma coluna
		sal	eax,2 			; Multiplica por 4
		mov	ecx,eax 		; Ecx controla a posição no vetor

		; Carrega os valores para os registradores e faz a soma
		mov	eax,[esi+ecx]
		mov	edx,[edi+ecx]
		add	eax,edx 		; Soma as matrizes (A+B)
		mov	[ebx+ecx],eax		; Guarda na matriz(vetor) auxiliar

		add	edx,edx 		; (2B)
		mov	[edi+ecx],edx 		; Substitui o elemento X para 2X


	cmp	DWORD [j],0
	jne	for2

	cmp	DWORD [i],0
	jne	for1

;(A+B * 2B)------------------------------------------------------------------------------

	xor	esi,esi
	mov     DWORD [i],tam
forF1:
        dec     DWORD [i]
        mov     DWORD [j],tam

       forF2:
                dec     DWORD [j]
                mov     DWORD [soma],0
                mov     DWORD [k],tam

                forF3:
            	        dec     DWORD [k]
            	        mov     eax,tam
                   	mov     edx,[i]
                    	mul     edx		; Multiplica tamanho da matriz pela linha
                    	add     eax,[k]		; Soma coluna
                    	sal     eax,2		; Multiplica por 4
                    	mov     ecx,eax		; Ecx controla a posição no vetor

                    	mov     eax,tam
                    	mov     edx,[k]
                    	mul     edx		; Multiplica tamanho da matriz pela linha
                    	add     eax,[j]		; Soma coluna
                    	sal     eax,2		; Multiplica por 4
                    	mov     esi,eax		; Esi controla a posição no vetor

                    	mov     eax,[ebx+ecx]	; Eax pega valor de (A+B)
                    	mov     edx,[edi+esi]	; Edx pega valor de 2B
                    	mul     edx

                    	add     [soma],eax	; Salva valor da multiplicação na soma parcial
                    	cmp     DWORD [k],0
                    	jne     forF3
		    	push    DWORD [soma]	; Salva a soma final do elemento na pilha

                cmp     DWORD [j],0
                jne     forF2

	cmp     DWORD [i],0
        jne     forF1


;(Menor elemento da diagonal principal)--------------------------------------------------

	mov	ecx,[esp]			; Ecx recebe primeiro elemento da matriz final (que está no topo da pilha)
	mov	[menor],ecx			; Primeiro elemento da matriz final inicia-se como o menor
	mov	DWORD [i],tam

Cond_Busca:
	dec	DWORD [i]
	mov     eax,tam
      	mov     edx,[i]
        mul     edx				; Multiplica tamanho da matriz pela linha
	add	eax,[i]				; Soma linha (apenas elementos da diagonal principal são validos)
	sal	eax,2				; Multiplica por 4
	mov	edx,eax				; Edx controla posição no vetor

	mov	ebx,[esp+edx]			; Ebx recebe o elemento atual
	cmp	ebx,[menor]			; Compara com o menor
	jl	Troca
	cmp	DWORD [i],0
	jne	Cond_Busca
	jmp	Fim

Troca:
	mov	[menor],ebx
	cmp	DWORD [i],0
	jne	Cond_Busca

Fim: 
	mov	eax,[menor]			; Retorna menor elemento da diagonal principal
	mov 	esp,ebp
	pop 	ebp
	ret
