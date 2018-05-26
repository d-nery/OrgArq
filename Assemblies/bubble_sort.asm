## bubble_sort.asm
# Organização e Arquitetura de Computadores I
# Escola Politécnica da USP
#
# Author: Daniel Nery Silva de Oliveira
#
# Base Algorithm:
# do
#     swapped = false
#     for i = 1 to indexOfLastUnsortedElement-1
#         if leftElement > rightElement
#             swap(leftElement, rightElement)
#             swapped = true
# while swapped
#
# Tested with QtSpim 9.1.20 with
# Delayed branches and delayed loads
##

# System calls
PRINT_INT    = 1    # $a0 = int
PRINT_STRING = 4    # $a0 = addr of string
EXIT         = 10

# Data area
.data
array:   .word     3953, 22429, 4748, 14934, 597, 22326, 13332, 5903, 23592, 13284, 6758, 22897, 25622, 19883, 23370, 28409, 18405, 1849, 23670, 18460, 20962, 14310, 24075, 15153, 23865, 17654, 22332, 26672, 20690, 15568, 17832, 9721, 6049, 29792, 16638, 29151, 13042, 1704, 25282, 22003, 23739, 23796, 14156, 24128, 22890, 6436, 11204, 2698, 23184, 10795, 9565, 2208, 15279, 23494, 29663, 8696, 8929, 21416, 21689, 12246, 8577, 26850, 8461, 17583, 11221, 4591, 14788, 19075, 19323, 15289, 12008, 11630, 24330, 12122, 25295, 23184, 6829, 5386, 11091, 16355, 19622, 25057, 23630, 14777, 2091, 6218, 6319, 14488, 11158, 29780, 19390, 6968, 13496, 5968, 23298, 10095, 9616, 23483, 2342, 10709
size:    .word     100
space:   .asciiz   " "

# Text area
.text
.globl main

main:
    la      $t0, size           # Temporary load size addres
    lw      $s0, ($t0)          # s0 = last unsorted element index
    nop

    addi    $t0, $0, 1          # swapped flag, 1 because outer loop must happen at least once

o_loop:                         ## Outer Loop
    beq     $t0, $0, print      # if no one was swapped, end
    nop

    add     $t0, $0, $0         # swapped = false (0)
    addi    $t2, $0, -1         # t2 = i = -1 (becomes 0 in inner loop)
    addi    $s0, $s0, -1        # last unsorted--

    la      $t1, array          # t1 = base array addres
    addi    $t1, $t1, -4

i_loop:                         ## Inner Loop
    addi    $t2, $t2, 1         # t2++
    addi    $t1, $t1, 4

    beq     $t2, $s0, o_loop    # if i = last unsorted element index, go back to outer loop
    nop

    lw      $s1, 0($t1)         # array[i]    (left element)
    lw      $s2, 4($t1)         # array[i+1]  (right element)
    nop
    sgt     $t4, $s1, $s2       # left > right ?

    beq     $t4, $0, i_loop     # left < right, continue looping
    nop

    sw      $s1, 4($t1)         # left > right, swap
    sw      $s2, 0($t1)
    addi    $t0, $0, 1          # swapped = true (1)

    j       i_loop

### Print
print:
    la      $t0, size           # Amount of data do print
    lw      $s0, ($t0)

    la      $t0, array          # Basse array address
    add     $t1, $0, $0         # Amount of data printed

print_loop:
    lw      $a0, ($t0)
    li      $v0, PRINT_INT
    syscall

    la      $a0, space
    li      $v0, PRINT_STRING
    syscall

    addi    $t0, $t0, 4
    addi    $t1, $t1, 1
    slt     $t2, $t1, $s0

    bne     $t2, $0, print_loop # Keeps printing until last element is reached
    nop

end:
    li      $v0, EXIT
    syscall
