_start:
    ADDI sp , zero , 0x700 
    JAL ra, main
    EBREAK

main:
    # prolog: allocate stack frame
    # expanding stack with 8 bytes: 4 for local var, 4 for ra of _start
    ADDI sp, sp, -8 
    # storing ra of start in the ‘last’ block in the stacks
    SW ra, 4(sp) 

    # int a = 3
    # local var
    ADDI s1, zero, 3 
    # stacking local vars
    SW s1, 0(sp)

    # passing address of local var as a parameter
    ADDI a0, sp, 0
    # jumping to times3
    JAL ra, times3

    # restoring value of local var from the stack
    LW s1, 0(sp)
    # return value of local var + return value of times3
    ADD a0, s1, a0

    # epilog: restore original ra
    # restoring value of ra from the stack
    LW ra, 4(sp)
    # resize stack
    ADDI sp, sp, 8

    # return to caller
    JALR zero, 0(ra)

times3: 
    # load value of the passed parameter and save it in t0
    LW t0, 0(a0)
    # t0 * 2
    ADD t1, t0, t0
    # return t0 * 3
    ADD a0, t1, t0
    # return to caller
    JALR zero, 0(ra)
