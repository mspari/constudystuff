_start:
    ADDI sp , zero , 0x700 
    JAL ra, main
    EBREAK

main:
    # prolog
    ADDI sp, sp, -8
    SW ra, 4(sp)

    # local variable a
    ADDI s1, zero, 3
    SW s1, 0(sp)

    # global variable g
    ADDI t0, zero, 4
    SW t0, 0xF00(zero)

    # pass address as params and call function
    ADDI a0, sp, 0
    JAL ra, addglobal

    # restore variable
    LW s1, 0(sp)

    # epilog
    LW ra, 4(sp)
    ADDI sp, sp, 8

    # return
    JALR zero, 0(ra)

addglobal:
    # load param
    LW t0, 0(a0)
    # load value of global variable
    LW t1, 0xF00(zero)

    ADDI a0, t0, t1
    JALR zero, 0(ra)