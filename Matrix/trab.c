/* Realiza a seguinte operação matricial: (A+B) x 2B e retornar o menor valor da diagonal principal
Operação deve ser realizada em linguagens C, Assembly sintaxe INTEL/NASM e Assembly sintaxe AT&T/GAS
Para compilar:
 - NASM:	nasm -f elf -o trabAsm.o trabAsm.asm
 - GAS: 	as --32 -o trabGas.o trabGas.s
 - C:	gcc -m32 -std=c99 -o trab trab.c trabAsm.o trabGas.o 
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

const int tam=5;

int CriaMatrizes(int A[][tam],int B[][tam],int va[],int vbn[],int aux[], int i,int j, int vbg[]){

int indice=0;

	printf("A:\n");
	for(i=0;i<tam;i++) {
		for(j=0;j<tam;j++) {
			A[i][j]=rand()%10;
			B[i][j]=rand()%10;
			va[indice]=A[i][j];
			vbn[indice]=B[i][j];
			vbg[indice]=B[i][j];
			aux[indice]=0;
			indice++;
			printf("%d ",A[i][j]);
		}
		printf("\n");
	}
	printf("\n\nB:\n");
	for(i=0;i<tam;i++) {
		for(j=0;j<tam;j++) {
			printf("%d ",B[i][j]);
		}
		printf("\n");
	}
	
}

void Soma_AB(int A[][tam],int B[][tam],int C[][tam],int i,int j) {
	printf("\n\n(A+B):\n");
	for(i=0;i<tam;i++) {
		for(j=0;j<tam;j++) {
			C[i][j]=A[i][j]+B[i][j];
			printf("%d ",C[i][j]);
		}
		printf("\n");
	}
}

void Mult_B(int B[][tam], int i, int j) {

	printf("\n\n(2B):\n");
	for(i=0;i<tam;i++) {
		for(j=0;j<tam;j++) {
			B[i][j]=2*B[i][j];
			printf("%d ",B[i][j]);
		}
		printf("\n");
	}
}

void Mult_CB(int A[][tam], int B[][tam], int C[][tam], int i, int j) {
	int k=0;

	for(i=0;i<tam;i++)
		for(j=0;j<tam;j++)
			A[i][j]=0;
	printf("\n\n(A+B * 2B):\n");

	for(i=0;i<tam;i++) {
		for(j=0;j<tam;j++) {
			for(k=0;k<tam;k++) {
				A[i][j]+=C[i][k]*B[k][j];
			}
		printf("%d ",A[i][j]);
		}
	printf("\n");
	}
}

int main() {

    int max=tam*tam;
    int menor=0;
    int A[tam][tam], B[tam][tam], C[tam][tam], va[max], vbn[max], aux[max], vbg[max];
    int i=0, j=0, r=0;

	srand(time(NULL));
	CriaMatrizes(A,B,va,vbn,aux,i,j,vbg);

	//Clock C
	float x=(float) clock()/CLOCKS_PER_SEC; 
	Soma_AB(A,B,C,i,j);
	Mult_B(B,i,j);
	Mult_CB(A,B,C,i,j);
	printf("\n\n");

	menor=A[0][0];
	for(i=1;i<tam;i++) {
		if(A[i][i]<menor) {
			menor=A[i][i];
		}
	}
	float y=(float) clock()/CLOCKS_PER_SEC; 
	printf("\nMenor valor C: %d	        Tempo: %.6fs",menor,y-x);

	extern int C_Asm (int [max], int [max], int [max]);

	//Clock Nasm
	x=(float) clock()/CLOCKS_PER_SEC; 
	r = C_Asm(va,vbn,aux);
	y=(float) clock()/CLOCKS_PER_SEC;
	printf("\nMenor valor Nasm: %d		Tempo: %.6fs\n",r,y-x);

	extern int C_Gas (int [max], int [max], int [max]);

	//Clock Gas
	x=(float) clock()/CLOCKS_PER_SEC; 
	r = C_Gas(va,vbg,aux);
	y=(float) clock()/CLOCKS_PER_SEC;
	printf("Menor valor Gas: %d		Tempo: %.6fs\n",r,y-x);
	
}
