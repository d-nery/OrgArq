## Multiplicacao de Matrizes
# Recebe matrizes A(mxn) e B(nxp)
# Realiza a multiplicacao e guarda em C(mxp)
#
# Algoritmo base:
# for i = 1 to m
#     for j = 1 to p:
#         sum = 0
#         for k = 1 to n:
#             sum = sum + A[i][k] * B[k][j]
#         C[i][j] = sum
##

# System calls
PRINT_INT    = 1    # $a0 = int
PRINT_STRING = 4    # $a0 = addr of string
EXIT         = 10

.data
A:      .word   1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
B:      .word   11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30
C:      .space  16384    # Maximum size 64 * 64 (*4 bytes/int)

m:      .word   3
n:      .word   4
p:      .word   5

space:  .asciiz " "
enter:  .asciiz "\n"

.text
.globl main

main:
    la      $t0, m
    la      $t1, n
    la      $t2, p
    lw		$s0, 0($t0)         # s0 = m
    lw		$s1, 0($t1)         # s1 = n
    lw		$s2, 0($t2)         # s2 = p

    la      $s3, A              # s3 -> matriz A
    la      $s4, B              # s4 -> matriz B
    la      $s5, C              # s5 -> matriz C

    li      $t0, 0              # t0 = i = 0
    li      $t1, 0              # t1 = j = 0
    li      $t2, 0              # t2 = k = 0

i_loop:
    li      $t1, 0              # t1 = j = 0

j_loop:
    add     $t6, $0, $0         # t6 = sum = 0
    li      $t2, 0              # t2 = k = 0

k_loop:
    mult	$t0, $s1			#
    mflo	$t7					# t7 = i * n
    add     $t7, $t7, $t2       # t7 = i * n + k
    sll     $t7, $t7, 2         # t7 * 4 (bytes)

    add     $t3, $s3, $t7       # t3 = A[i][k]

    mult	$t2, $s2			#
    mflo	$t7					# t7 = k * p
    add     $t7, $t7, $t1       # t7 = k * p + j
    sll     $t7, $t7, 2         # t7 * 4 (bytes)

    add     $t4, $s4, $t7       # t4 = B[k][j]

    lw      $t7, ($t3)
    lw      $t8, ($t4)

    mult	$t7, $t8			#
    mflo	$t7					# t7 = A[i][k] * B[k][j]

    add     $t6, $t6, $t7       # sum = sum + A[i][j] * B[k][j]

    addi    $t2, $t2, 1        # k++
    bne     $t2, $s1, k_loop   # se k != n, continua no loop

    ## End j_loop
    mult	$t0, $s2			#
    mflo	$t7					# t7 = i * p
    add     $t7, $t7, $t1       # t7 = i * p + j
    sll     $t7, $t7, 2         # t7 * 4 (bytes)

    add     $t5, $s5, $t7
    sw		$t6, ($t5)

    addi    $t1, $t1, 1         # j++
    bne     $t1, $s2, j_loop    # se j != p, continua no loop

    ## End k_loop
    addi	$t0, $t0, 1 		# i++
    bne     $t0, $s0, i_loop    # se i != m, continua no loop

print:
    li      $t0, 0      # i (s0 = m)
    li      $t1, 0      # j (s2 = p)
    la      $s1, C      # C

print_o_loop:
    li      $t1, 0

    print_i_loop:
        lw      $a0, ($s1)
        li      $v0, PRINT_INT
        syscall

        la      $a0, space
        li      $v0, PRINT_STRING
        syscall

        addi    $s1, $s1, 4
        addi	$t1, $t1, 1			# j++
        bne     $t1, $s2, print_i_loop
        nop

    la      $a0, enter
    li      $v0, PRINT_STRING
    syscall

    addi	$t0, $t0, 1			# i++
    bne     $t0, $s0, print_o_loop # se i != m, continua imprimindo


end:
    li $v0, EXIT
    syscall
