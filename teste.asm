# Programa de testes assembly mips
    .text
    .globl __start

__start:
    li      $t0, 3
    li      $t1, 4
    addu    $t2, $t0, $t1
    sll     $t3, $t2, 2

    # Exit
    addiu   $v0, $0, 10
    syscall
