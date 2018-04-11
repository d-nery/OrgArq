# Teste sort s

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
array:   .word     3953, 22429, 4748, 14934, 597, 22326, 13332, 5903, 23592, 13284, 6758, 22897, 25622, 19883, 23370, 28409, 18405, 1849, 23670, 18460, 20962, 14310, 24075, 15153, 23865, 17654, 22332, 26672, 20690, 15568, 17832, 9721, 6049, 29792, 16638, 29151, 13042, 1704, 25282, 22003, 23739, 23796, 14156, 24128, 22890, 6436, 11204, 2698, 23184, 10795, 9565, 2208, 15279, 23494, 29663, 8696, 8929, 21416, 21689, 12246, 8577, 26850, 8461, 17583, 11221, 4591, 14788, 19075, 19323, 15289, 12008, 11630, 24330, 12122, 25295, 23184, 6829, 5386, 11091, 16355, 19622, 25057, 23630, 14777, 2091, 6218, 6319, 14488, 11158, 29780, 19390, 6968, 13496, 5968, 23298, 10095, 9616, 23483, 2342, 10709
size:    .word     400
space:   .asciiz   " "

.text
.globl main

main:
    la   $t0, array         # Endereco base do array
    addi $t0, $t0, 400      # Endereço final do array (4bytes * 20elementos)

o_loop:
    add  $t1, $0, $0        # Flag que diz se já terminou o sort
    la   $a0, array         # Endereço incial array

i_loop:
    lw   $t2, 0($a0)        # Elemento atual
    lw   $t3, 4($a0)        # Proximo elemento
    sgt  $t5, $t2, $t3      # t5 = 1 se t2 > t3
    beq  $t5, $0, continue  # Se t5 for 1, nao precisa trocar
    addi $t1, $0, 1         # Se chegou aqui, entao precisa trocar, sort ainda nao acabou
    sw   $t2, 4($a0)        # troca t2 com t3
    sw   $t3, 0($a0)

continue:
    addi $a0, $a0, 4        # Proximo elemento
    bne  $a0, $t0, i_loop   # Volta pro loop se não chegou no fim do array
    bne  $t1, $0, o_loop    # Volta pro loop externo

### Print
print:
    la $t6, array

print_loop:
    lw $a0, ($t6)
    li $v0, PRINT_INT
    syscall

    la  $a0, space
    li  $v0, PRINT_STRING
    syscall

    addi $t6, $t6, 4
    bne  $t6, $t0, print_loop

end:
    li $v0, EXIT
    syscall
