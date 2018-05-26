# Teste I/O

.text
.globl __start

__start:
    # Print "7" to the console
    addiu   $a0, $zero, 7   # Load a0 with int to be printed
    addiu   $v0, $zero, 1   # Load v0 with syscall 1 = print_int
    syscall                 # Actually do the syscall

    # Read an int from the console
    addiu   $v0, $zero, 5   # Load v0 with syscall 5 = read_int
    syscall                 # read_int
    addu    $s0, $zero, $v0 # Move int to s0 to save it before exiting

    # Exit
    addiu   $v0, $zero, 10  # Prepare to exit (system call 10)
    syscall                 # exit
