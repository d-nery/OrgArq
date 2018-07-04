.globl __start
__start:
  addi $zero,$zero,0
 addi $at,$zero,1
  addi $zero,$zero,0
 sll $at,$at,28
  addi $zero,$zero,0
 sw $zero,10060($at)
  addi $zero,$zero,0
 
  addi $zero,$zero,0
 addi $v1,$zero,20
 sw $v1,0($at)

 addi $v1,$zero,14
 sw $v1,4($at)

 addi $v1,$zero,19
 sw $v1,8($at)

 addi $v1,$zero,2
 sw $v1,12($at)

 addi $v1,$zero,8
 sw $v1,16($at)

 addi $v1,$zero,12
 sw $v1,20($at)

 addi $v1,$zero,10
 sw $v1,24($at)

 addi $v1,$zero,7
 sw $v1,28($at)

 addi $v1,$zero,3
 sw $v1,32($at)

 addi $v1,$zero,17
 sw $v1,36($at)

 addi $v1,$zero,1
 sw $v1,40($at)

 addi $v1,$zero,20
 sw $v1,44($at)

 addi $v1,$zero,18
 sw $v1,48($at)

 addi $v1,$zero,6
 sw $v1,52($at)

 addi $v1,$zero,11
 sw $v1,56($at)

 addi $v1,$zero,9
 sw $v1,60($at)

 addi $v1,$zero,13
 sw $v1,64($at)

 addi $v1,$zero,5
 sw $v1,68($at)

 addi $v1,$zero,15
 sw $v1,72($at)

 addi $v1,$zero,4
 sw $v1,76($at)

 addi $v1,$zero,16
 sw $v1,80($at)

 
  addi $zero,$zero,0
 lw $v0,10000($at)
  addi $zero,$zero,0
 addi $v0,$at,4
  addi $zero,$zero,0
 sw $v0,10000($at)
  addi $zero,$zero,0
 lw $v0,10004($at)
  addi $zero,$zero,0
 lw $v0,($at)
  addi $zero,$zero,0
 sw $v0,10004($at)
  addi $zero,$zero,0
 lw $v0,10004($at)
  addi $zero,$zero,0
 addi $v1,$zero,4
  addi $zero,$zero,0
 jal multiplicar
  addi $zero,$zero,0
 sw $v0,10004($at)
  addi $zero,$zero,0
 lw $v0,10004($at)
  addi $zero,$zero,0
 add $v0,$v0,$at
  addi $zero,$zero,0
 sw $v0,10004($at)
  addi $zero,$zero,0

  addi $zero,$zero,0
loop_pivo:
  addi $zero,$zero,0
 lw $v1,10004($at)
  addi $zero,$zero,0
 lw $v0,10000($at)
  addi $zero,$zero,0
 beq $v0,$v1,sair_final
  addi $zero,$zero,0
 sw $v1,10004($at)
  addi $zero,$zero,0
 sw $v0,10000($at)
  addi $zero,$zero,0
 lw $v0,10000($at)
  addi $zero,$zero,0
 lw $v1,10008($at)
  addi $zero,$zero,0
 lw $v1,($v0)
  addi $zero,$zero,0
 sw $v1,10008($at)
  addi $zero,$zero,0
 lw $v0,10012($at)
  addi $zero,$zero,0
 lw $v1,10000($at)
  addi $zero,$zero,0
 addi $v0,$v1,0
  addi $zero,$zero,0
 sw $v0,10012($at)
  addi $zero,$zero,0
 sw $v1,10000($at)
  addi $zero,$zero,0
 lw $v0,10016($at)
  addi $zero,$zero,0
 lw $v1,10000($at)
  addi $zero,$zero,0
 addi $v0,$v1,0
  addi $zero,$zero,0
 sw $v0,10016($at)
  addi $zero,$zero,0
 sw $v1,10000($at)
  addi $zero,$zero,0
loop_iterador:
  addi $zero,$zero,0
 lw $v1,10004($at)
  addi $zero,$zero,0
 lw $v0,10012($at)
  addi $zero,$zero,0
 beq $v0,$v1,sair_loop_iterador
  addi $zero,$zero,0
 sw $v1,10004($at)
  addi $zero,$zero,0
 sw $v0,10012($at)
  addi $zero,$zero,0
 lw $v0,10012($at)
  addi $zero,$zero,0
 addi $v0,$v0,4
  addi $zero,$zero,0
 sw $v0,10012($at)
  addi $zero,$zero,0
 lw $v0,10012($at)
  addi $zero,$zero,0
 lw $v1,10020($at)
  addi $zero,$zero,0
 lw $v1,($v0)
  addi $zero,$zero,0
 sw $v1,10020($at)
  addi $zero,$zero,0
 
  addi $zero,$zero,0
 lw $v0,10020($at)
  addi $zero,$zero,0
 lw $v1,10008($at)
  addi $zero,$zero,0
 slt $v0,$v0,$v1
  addi $zero,$zero,0
 beq $v0,$zero,nao_eh_menor
  addi $zero,$zero,0
 
  addi $zero,$zero,0
 lw $v1,10020($at)
  addi $zero,$zero,0
 lw $v0,10008($at)
  addi $zero,$zero,0
 add $v0,$zero,$v1
  addi $zero,$zero,0
 sw $v1,10020($at)
  addi $zero,$zero,0
 sw $v0,10008($at)
  addi $zero,$zero,0
 lw $v0,10016($at)
  addi $zero,$zero,0
 lw $v1,10012($at)
  addi $zero,$zero,0
 add $v0,$zero,$v1
  addi $zero,$zero,0
 sw $v0,10016($at)
  addi $zero,$zero,0
 sw $v1,10012($at)
  addi $zero,$zero,0
 
  addi $zero,$zero,0
nao_eh_menor:
  addi $zero,$zero,0
 j loop_iterador
  addi $zero,$zero,0
 
  addi $zero,$zero,0
sair_loop_iterador:
  addi $zero,$zero,0
 lw $v0,10000($at)
  addi $zero,$zero,0
 lw $v1,10016($at)
  addi $zero,$zero,0
 jal swap
  addi $zero,$zero,0
 lw $v0,10000($at)
  addi $zero,$zero,0
 addi $v0,$v0,4
  addi $zero,$zero,0
 sw $v0,10000($at)
  addi $zero,$zero,0
 j loop_pivo
  addi $zero,$zero,0
 
  addi $zero,$zero,0
sair_final:
 addi $v0, $0, 10 # Prepare to exit (system call 10)
 syscall # Exit


  addi $zero,$zero,0
#troca elemento apontado
  addi $zero,$zero,0
swap:
  addi $zero,$zero,0
 sw $v0,10040($at)
  addi $zero,$zero,0
 sw $v1,10044($at)
  addi $zero,$zero,0
 lw $v1,10048($at)
  addi $zero,$zero,0
 lw $v1,($v0)
  addi $zero,$zero,0
 sw $v1,10048($at)
  addi $zero,$zero,0
 lw $v1,10044($at)
  addi $zero,$zero,0
 lw $v0,10052($at)
  addi $zero,$zero,0
 lw $v0,($v1)
  addi $zero,$zero,0
 sw $v0,10052($at)
  addi $zero,$zero,0
 lw $v0,10040($at)
  addi $zero,$zero,0
 lw $v1,10052($at)
  addi $zero,$zero,0
 sw $v1,($v0)
  addi $zero,$zero,0
 sw $v1,10052($at)
  addi $zero,$zero,0
 lw $v1,10044($at)
  addi $zero,$zero,0
 lw $v0,10048($at)
  addi $zero,$zero,0
 sw $v0,($v1)
  addi $zero,$zero,0
 sw $v0,10048($at)
  addi $zero,$zero,0
 jr $ra
  addi $zero,$zero,0

  addi $zero,$zero,0
#v0 = v0*v1
  addi $zero,$zero,0
multiplicar: 
  addi $zero,$zero,0
 sw $v0,10024($at)
  addi $zero,$zero,0
 sw $v1,10028($at)
  addi $zero,$zero,0
 lw $v0,10032($at)
  addi $zero,$zero,0
 addi $v0,$zero,0
  addi $zero,$zero,0
 sw $v0,10032($at)
  addi $zero,$zero,0
 lw $v0,10036($at)
  addi $zero,$zero,0
 addi $v0,$zero,0
  addi $zero,$zero,0
 sw $v0,10036($at)
  addi $zero,$zero,0
loop_mult:
  addi $zero,$zero,0
 lw $v0,10032($at)
  addi $zero,$zero,0
 lw $v1,10028($at)
  addi $zero,$zero,0
 beq $v0,$v1,sair_mult
  addi $zero,$zero,0
 sw $v0,10032($at)
  addi $zero,$zero,0
 sw $v1,10028($at)
  addi $zero,$zero,0
 lw $v0,10032($at)
  addi $zero,$zero,0
 addi $v0,$v0,1
  addi $zero,$zero,0
 sw $v0,10032($at)
  addi $zero,$zero,0
 lw $v1,10024($at)
  addi $zero,$zero,0
 lw $v0,10036($at)
  addi $zero,$zero,0
 add $v0,$v0,$v1
  addi $zero,$zero,0
 sw $v1,10024($at)
  addi $zero,$zero,0
 sw $v0,10036($at)
  addi $zero,$zero,0
 j loop_mult
  addi $zero,$zero,0
sair_mult:
  addi $zero,$zero,0
 lw $v0,10036($at)
  addi $zero,$zero,0
 jr $ra
  addi $zero,$zero,0
