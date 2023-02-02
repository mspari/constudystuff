_start:
    ADDI sp , zero , 0x700 
    JAL ra, main
    EBREAK

main:
    # prolog
    ADDI sp, sp, -8
    SW ra, 4(sp)

    # local variable a
    ADDI s1, zero, 7
    SW s1, 0(sp)

    # global variable g
    ADDI t0, zero, 2
    SW t0, 0xF00(zero)

    # pass params and call function
    ADDI a0, zero, 0xF00
    ADD a1, zero, s1
    JAL ra, subf

    # restore local variable
    LW s1, 0(sp)

    # calculate result
    ADDI t0, zero, a0
    ADD a0, t0, s1

    # epilog
    LW ra, 4(sp)
    ADDI sp, sp, 8

    # return
    JALR zero, 0(ra)

subf:
    # load param *p
    LW t0, 0(a0)

    # calculate result
    ADDI a0, a1, t0
    
    # return result
    JALR zero, 0(ra)