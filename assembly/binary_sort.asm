###############################################################################
# Startup code
#
# Initializes the stack pointer, calls main, and stops simulation.
#
# Memory layout:
#   0 ... ~0x300  program
#   0x7EC       Top of stack, growing down
#   0x7FC       stdin/stdout
#
###############################################################################

.org 0x00
_start:
  ADDI sp, zero, 0x7EC
  ADDI fp, sp, 0

  # set saved registers to unique default values
  # to make checking for correct preservation easier
  LUI  s1, 0x11111
  ADDI s1, s1, 0x111
  ADD  s2, s1, s1
  ADD  s3, s2, s1
  ADD  s4, s3, s1
  ADD  s5, s4, s1
  ADD  s6, s5, s1
  ADD  s7, s6, s1
  ADD  s8, s7, s1
  ADD  s9, s8, s1
  ADD  s10, s9, s1
  ADD  s11, s10, s1

  JAL  ra, main
  EBREAK


###############################################################################
###############################################################################
# Function: int binary_search(int* A, int low, int high, int x)
#
binary_search:
  # prolog
  ADDI sp, sp, -28
  SW   ra, 24(sp)
  SW   fp, 20(sp)
  ADDI fp, sp, 28

  # size_t stacked_s1 = s1;
  SW s1, 16(sp) 
  # size_t stacked_s2 = s2;
  SW s2, 12(sp) 
  # size_t stacked_s3 = s3;
  SW s3, 8(sp) 
  # size_t stacked_s4 = s4;
  SW s4, 4(sp)
  # size_t stacked_s5 = s5;
  SW s5, 0(sp)

  # s1 = a2;
  ADDI s1, a2, 0
  
  # s2 = a3;
  ADDI s2, a3, 0

  # s4 = a0;
  ADDI s4, a0, 0

  # s5 = a4;
  ADDI s5, a4, 0

  # s3 = zero;
  ADDI s3, zero, 0

  # if ((int) s2 >= (int) s1) goto outerif;
  BGE s2, s1, .outerif

  # t4 = 2
  ADDI t4, zero, 2

  # t2 = s1 << t4
  SLL t2, s1, t4

  # t3 = s4 + t2; 
  ADD t3, s4, t2

  # t4 = *(int*) t3;
  LW t4, 0(t3)
  
  # if ((int) t4 < (int) s5) goto conditionfour;
  BLT t4, s5, .conditionfour

  # goto conditionfive;
  JAL zero, .conditionfive

  # return;
  JALR zero, 0(ra)

  #############################################################
  #############################################################

  .outerif:

  # t2 = s1 + s2;
  ADD t2, s1, s2

  # s3 = t2 / 2;
  # divide by two equals one shift to the right
  ADDI t4, zero, 1
  SRL s3, t2, t4

  # t4 = 2
  ADDI t4, zero, 2

  # t2 = s3 << t4
  SLL t2, s3, t4

  # t3 = s4 + t2;
  ADD t3, s4, t2
  
  # t4 = *(int*) t3;
  LW t4, 0(t3)

  # if ((int) s5 == (int) t4) goto conditionone;
  BEQ s5, t4, .conditionone

  # if ((int) s5 < (int) t4) goto conditiontwo;
  BLT s5, t4, .conditiontwo

  # goto conditionthree;
  JAL zero, .conditionthree

  #############################################################

  .conditionone:
    # a0 = s3;
    ADDI a0, s3, 0

    # goto restorestack;
    JAL zero, .restorestack

  #############################################################

  .conditiontwo:
    # a2 = s1;
    ADDI a2, s1, 0
  
    # a3 = s3 - 1; 
    ADDI a3, s3, -1

    # binary_search();
    JAL ra, binary_search

    # goto restorestack;
    JAL zero, .restorestack

  #############################################################

  .conditionthree:
    # a2 = s3 + 1;
    ADDI a2, s3, 1

    # a3 = s2;
    ADDI a3, s2, 0

    # binary_search();
    JAL ra, binary_search

    # goto restorestack;
    JAL zero, .restorestack

  #############################################################

  .conditionfour:

    # a0 = s1 + 1;
    ADDI a0, s1, 1

    # goto restorestack;
    JAL zero, .restorestack

  #############################################################
  
  .conditionfive:

    # a0 = s1;
    ADDI a0, s1, 0
    
    # goto restorestack;
    JAL zero, .restorestack

  #############################################################

  .restorestack:
    # epilog

    # s5 = stacked_s5;
    LW s5, 0(sp)
    # s4 = stacked_s4;
    LW s4, 4(sp)
    # s3 = stacked_s3;
    LW s3, 8(sp)
    # s2 = stacked_s2;
    LW s2, 12(sp) 
    # s1 = stacked_s1;
    LW s1, 16(sp)

    LW   fp, 20(sp)
    LW   ra, 24(sp)
    ADDI sp, sp, 28
  
    # return;
    JALR zero, 0(ra)

  #############################################################


###############################################################################
###############################################################################
# Function: void insertion_sort(int* A, int size)
#
insertion_sort:

    # Prolog: Allocate the stack frame
    ADDI sp, sp, -24       # allocate space for two integers (ra, fp)
    SW ra, 20(sp)           # store the return address into the first stack slot
    SW fp, 16(sp)           # store the original frame pointer into the second slot
    ADDI fp, sp, 24         # update the frame pointer to the original stack pointer value

    # size_t stacked_s4 = s4;
    SW s4, 12(sp)
    # size_t stacked_s5 = s5;
    SW s5, 8(sp)
    # size_t stacked_s6 = s6;
    SW s6, 4(sp)
    # size_t stacked_s7 = s7;
    SW s7, 0(sp)

    # s6 = a0;
    ADDI s6, a0, 0

    # s7 = a1;
    ADDI s7, a1, 0

    # t0 = zero;
    ADDI t0, zero, 0

    # s4 = zero;
    ADDI s4, zero, 0
    
    # t1 = zero;
    ADDI t1, zero, 0

    # s5 = 1;
    ADDI s5, zero, 1

    .forloophead:
    # if ((int) s5 < (int) s7) goto forloopinner;
    BLT s5, s7, .forloopinner


    # Epilog: Restore the original ra, fp, and sp values and return
    
    # s7 = stacked_s7;
    LW s7, 0(sp)
    # s6 = stacked_s6;
    LW s6, 4(sp)
    # s5 = stacked_s5;
    LW s5, 8(sp)
    # s4 = stacked_s4;
    LW s4, 12(sp)

    LW fp, 16(sp)
    LW ra, 20(sp)
    ADDI sp, sp, 24

    # return;
    JALR zero, 0(ra)

    #############################################################
    #############################################################
   
    .forloopinner:

    # t4 = 2
    ADDI t4, zero, 2

    # t2 = s5 << t4
    SLL t2, s5, t4

    # t3 = s6 + t2; 
    ADD t3, s6, t2

    # s4 = *(int*) t3;
    LW s4, 0(t3)

    # a2 = zero;
    ADDI a2, zero, 0

    # a3 = s5;
    ADDI a3, s5, 0
    
    # a4 = s4;
    ADDI a4, s4, 0

    # binary_search();
    JAL ra, binary_search
    
    # t1 = a0;
    ADDI t1, a0, 0

    # t0 = s5;
    ADDI t0, s5, 0

    .whileloophead:
    # if ((int) t1 < (int) t0) goto whileloopinner;
    BLT t1, t0, .whileloopinner

    # t4 = 2
    ADDI t4, zero, 2

    # t2 = t1 << t4
    SLL t2, t1, t4

    # t3 = s6 + t2; 
    ADD t3, s6, t2

    # *(int*) t3 = s4;
    SW s4, 0(t3)

    # s5 = s5 + 1;
    ADDI s5, s5, 1

    # a0 = s6;
    ADDI a0, s6, 0

    # goto forloophead;
    JAL zero, .forloophead

    #############################################################

    .whileloopinner:

    # t4 = 2
    ADDI t4, zero, 2

    # t2 = t0 << t4
    SLL t2, t0, t4

    # t3 = s6 + t2;
    ADD t3, s6, t2

    # t4 = t3 - sizeof(int);
    ADDI t4, t3, -4

    # *(int*) t3 = *(int*) t4;
    LW t5, 0(t4) # lw $2, 4($4) / $2 is the destination register and $4 the address register
    SW t5, 0(t3) # sw $5, 8($7) / $7 is the register holding the memory address, 8 an offset and $5 is the source of the information that will be written in memory

    # t0 = t0 - 1;
    ADDI t0, t0, -1

    # goto .whileloophead;
    JAL zero, .whileloophead

    #############################################################


###############################################################################
###############################################################################
# Function: int input(int *A)
#
# Reads at most 10 values from stdin to the input array.
#
# Input args:
# a0: address for array A
# Return value:
# a0: Number of read elements
#
###############################################################################
input:
  ADDI t0, a0, 0                  # Save a0
  LW   a0, 0x7fc(zero)            # Load size
  ADDI t1, zero, 10               # Maximum
  ADDI t2, zero, 0                # Loop counter
.before_input_loop:
  BGE  t2, t1, .after_input_loop  # Maximum values reached
  BGE  t2, a0, .after_input_loop  # All values read

  # Read from stdin in store in array A
  LW   t3, 0x7fc(zero)
  SW   t3, 0(t0)
  # Pointer increments
  ADDI t0, t0, 4

  ADDI t2, t2, 1                  # Increment loop counter
  JAL  zero, .before_input_loop   # Jump to loop begin

.after_input_loop:
  JALR zero, 0(ra)

###############################################################################
# Function: void output(int size, int* A)
#
# Prints input and output values to stdout
#
# Input args:
# a0: Number of elements
# a1: address for array A
#
###############################################################################
output:
.before_output_loop:
  BEQ  a0, zero, .after_output_loop
  # Load values
  LW   t0, 0(a1)
  # Output Values to stdout
  SW   t0, 0x7fc(zero)
  # Pointer increments
  ADDI a1, a1, 4
  # Decrement loop counter
  ADDI a0, a0, -1
  # jump to beginning
  JAL  zero, .before_output_loop

.after_output_loop:
  JALR zero, 0(ra)

###############################################################################
# Function: main
#
# Calls input, insertion_sort, and output
#
###############################################################################
main:
  ADDI sp, sp, -64
  SW   ra, 60(sp)
  SW   s0, 56(sp)
  ADDI s0, sp, 64

  ADDI a0, s0, -52                # a0 = (size_t) A;
  JAL  ra, input                  # input();
  SW   a0, -56(s0)                # size = a0;

  ADDI a1, a0, 0                  # a1 = size;
  ADDI a0, s0, -52                # a0 = (size_t) A;
  JAL  ra, insertion_sort         # insertion_sort();

  LW   a0, -56(s0)                # a0 = size;
  ADDI a1, s0, -52                # a1 = (size_t) A;
  JAL  ra, output                 # output();

  ADDI a0, zero, 0                # return 0;

  LW   s0, 56(sp)
  LW   ra, 60(sp)
  ADDI sp, sp, 64
  JALR zero, 0(ra)
