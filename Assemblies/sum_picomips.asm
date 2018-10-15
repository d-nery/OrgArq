#Programa que soma resultados em registradores até contador ser igual a 0

.text
.globl main


main:
	addi	r1,r1,100
	addi	r2, r1, 10
	addi	r3, 1

loop:
	add		r2, r3
	addi	r1, -1
	bne		r1, r0, end
	j		loop

end:
    li      $v0, EXIT	#não sei se precisa dessa declaração no PicoMIPS
    syscall
