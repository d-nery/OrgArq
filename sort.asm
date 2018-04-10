# Teste sort

# System calls
# print_int    .equ 1    # $a0 = int
# print_float  .equ 2    # $f12 = float
# print_double .equ 3    # $f12 = double
# print_string .equ 4    # $a0 = addr of string
# read_int     .equ 5    # int in $v0
# read_float   .equ 6    # float in $f0
# read_double  .equ 7    # double in $f0
# read_string  .equ 8    # $a0 = buffer; $a1 = length
# sbrk         .equ 9    # $a0 = amount | add in $v0
# exit         .equ 10


.data
array: .word 93, 116, 69, 119, 64, 122, 121, 75, 38, 85, 27, 42, 7, 54, 50, 17, 92, 13, 127, 3
space: .asciiz " "

.text
.globl main

main:
    la   $t0, array     # Endereco base do array
    add  $t0, $t0, 80   # Endereço final do array (4bytes * 20elementos)

o_loop:
    add  $t1, $0, $0    # Flag que diz se já terminou o sort
    la   $a0, array     # Endereço incial array

i_loop:
    lw   $t2, 0($a0)        # Elemento atual
    lw   $t3, 4($a0)        # Proximo elemento
    slt  $t5, $t2, $t3      # t5 = 1 se t2 < t3
    beq  $t5, $0, continue  # Se t5 for 0, nao precisa trocar
    addi $t1, $0, 1         # Se chegou aqui, entao precisa trocar, sort ainda nao acabou
    sw   $t2, 4($a0)        # troca t2 com t3
    sw   $t3, 0($a0)

continue:
    addi $a0, $a0, 4   # Proximo elemento
    bne  $a0, $t0, i_loop # Volta pro loop se não chegou no fim do array
    bne  $t1, $0, o_loop  # Volta pro loop externo

print:
    la $a0, array

print_loop:
    li $v0, 1
    syscall

    add $t7, $0, $a0
    la  $a0, space
    li  $v0, 4
    syscall
    add $a0, $0, $t7

    addi $a0, $a0, 4
    bne  $a0, $t0, print_loop

end:
    li $v0, 10
    syscall
