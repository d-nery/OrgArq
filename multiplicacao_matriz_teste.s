# Teste multiplicacao de matrizes 2x2

# System calls
PRINT_INT    = 1    # $a0 = int
PRINT_FLOAT  = 2    # $f12 = float
PRINT_DOUBLE = 3    # $f12 = double
PRINT_STRING = 4    # $a0 = addr of string
READ_INT     = 5    # int in $v0
READ_FLOAT   = 6    # float in $f0
READ_DOUBLE  = 7    # double in $f0
READ_sTRING  = 8    # $a0 = buffer; $a1 = length
SBRK         = 9    # $a0 = amount | add in $v0
EXIT         = 10

.data
matrizA:   .word     1, 2, 3, 4
matrizB:    .word     5, 6, 7, 8
tamanhoA:    .word     2, 2
tamanhoB:    .word     2, 2
resultado:     .word     0:8
space:   .asciiz   " "
tab:   .asciiz   "\t"
newLine:   .asciiz   "\n" 
str: .asciiz "EXIT"

.text
.globl main

main:
    la $s0, matrizA     #s0 e o endereco inicial da matrizA
    la $s1, matrizB     #s1 e o endereco inicial da matrizB
    la $s2, tamanhoA    #s2 e o endereço inicial do tamanho da matrizA
    nop
    lw $s3, 4($s2)      #s3 tem o segundo valor do array tamanhoA (colunas da matrizA)
    nop
    lw $s2, 0($s2)      #s2 tem o segundo valor do array tamanhoA (linhas da matrizA)
    la $s4, tamanhoB    #s4  e o endereco inicial do tamanho da matrizB
    nop
    lw $s5, 4($s4)      #s5 tem o segundo valor do array tamanhoA (colunas da matrizB)
    nop
    lw $s4, 0($s4)      #s4 tem o segundo valor do array tamanhoA (linhas da matrizB)
    la $s6, resultado   #s6 tem o valor do resultado
    add $s7, $s5, $zero #s7 tem a quantidade de colunas da matriz resultado
    add $t0, $zero, $zero   #t0 tem 0. i = 0
    add $t1, $zero, $zero   #t1 tem 0. j = 0
    add $t2, $zero, $zero   #t2 tem 0. k = 0
    li $t3, 0       #Posicao do resultado tem 0

i_loop: beq $t0, $s2, i_end #Termina i_loop se i = linhas de matrizA
        nop
j_loop: beq $t1, $s5, j_end #Termina j_loop se j = colunas de matrizB
        nop
k_loop: beq $t2, $s4, k_end #Termina k_loop se k = linhas de matrizB
        nop

#corpo do loop

        li $t4, 0
        li $t5, 0
        li $t6, 0
                    #i * M + k - 1
        mul $t4, $t0, $s3   #i * #col em matrizA
        addu $t4, $t4, $t2   #t4 + k
        addi $t4, $t4, -1      # t4 - 1
        sll $t4, $t4, 2       # Converte index para byte
        addu $t4, $t4, $s0     # Agora aponta para valor  em matrizA[i][j]
        lw $t4, 0($t4)      # Carrega valor em matrizA[i][k]

                    #k * M + j - 1
        mul $t5, $t2, $s5   #k * #col em matrizB
        addu $t5, $t5, $t1   #t5 + j
        addi $t5, $t5, -1     #t5 -1
        sll $t5, $t5, 2       # Converte index para byte
        addu $t5, $t5, $s0    # Agora aponta para valor  em matrizB[k][j]
        lw $t5, 0($t5)      # Carrega valor em matrizB[k][j]

                    #i * M + j - 1
        mul $t6, $t0, $s7   #i * #col em matrizB
        addu $t6, $t6, $t1   #t6 + j
        addi $t6, $t6, -1     #t6 -1
        sll $t6, $t6, 2       # Converte index para byte
        addu $t6, $t6, $s6    # Agora aponta para valor em resultado[i][j]
        lw $t8, 0($t6)      # Carrega valor em resultado[i][j]

        mul $t7, $t4, $t5   #t7 = matrizA[i][k]*matrizB[k][j]

        addu $t9, $t8, $t7   #t9 = resultado[i][j] + matrizA[i][k]*matrizB[k][j]
        sw $t9, 0($t6)

        # Imprime elementos da matriz resultado[i][j] no console
        addiu $a0, $zero, $t9 # Carrega a0 com o int a ser mostrado
        addiu $v0, $zero, 1 # Carrega v0 com syscall 1 = print_int
        syscall 


#termina corpo do loop

        addi $t2, $t2, 1    #k++
        j k_loop        #Return to start of k_loop
k_end:
        addi $t1, $t1, 1    #j++
        li $t2, 0       #Resets k counter to 0
        j j_loop        #Return to start of j_loop
j_end:
        addi $t0, $t0, 1    #i++
        li $t1, 0       #Resets j counter to 0
        j i_loop        #Return to start of i_loop

i_end:      
        # Imprime string "EXIT" para demarcar fim das contas
        #addiu $a0, $zero, string # Carrega a0 com o int a ser mostrado
        #addiu $v0, $zero, 4 # Carrega v0 com syscall 4 = print_string
        #syscall 

