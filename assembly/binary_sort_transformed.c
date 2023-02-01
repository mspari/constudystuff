#include <stdio.h>
#include <stdint.h>

//-----------------------------------------------------------------------------
// RISC-V Register set
const size_t zero = 0;
size_t a0, a1;                      // fn args or return args
size_t a2, a3, a4, a5, a6, a7;      // fn args
size_t t0, t1, t2, t3, t4, t5, t6;  // temporaries
// Callee saved registers, must be stacked before using it in a function!
size_t s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11;
//-----------------------------------------------------------------------------

// args
// A = a0
// size / return of binary_search = a1
// low = a2
// high = a3
// x = a4

// int binary_search(int* A, int low, int high, int x)
void binary_search() {

    // VARIABLES
    // A = a0
    // low = a2 / s1
    // high = a3 / s2
    // x = a4
    // return > a1
    // m = s3

    // stack
    size_t stacked_s1 = s1;
    size_t stacked_s2 = s2;
    size_t stacked_s3 = s3;
    size_t stacked_s4 = s4;
    size_t stacked_s5 = s5;

    // store low, high, a0 & x
    s1 = a2;
    s2 = a3;
    s4 = a0;
    s5 = a4;

    // int m = 0;
    s3 = zero;

    // if (low <= high)
    if ((int) s2 >= (int) s1) goto outerif;

    // else of (low <= high)
    // if (x > A[low]) = (A[low] < x)
    // t2 = s1 * sizeof(int);
    t4 = 2;
    t2 = s1 << t4;
    t3 = s4 + t2; // pointer increment to get address of A[low]
    t4 = *(int*) t3; // get value of A[low]
    if ((int) t4 < (int) s5) goto conditionfour;

    // else of (t4 < s5)
    goto conditionfive;

    return;

    /* ------------------------------------------------------ */
    /* ------------------------------------------------------ */

    outerif:

    // m = (low + high) / 2;
    t2 = s1 + s2;
    s3 = t2 / 2;

    // if (x == A[m])
    // t2 = s3 * sizeof(int); // size of step
    t4 = 2;
    t2 = s3 << t4;
    t3 = s4 + t2; // pointer increment to get address of A[m]
    t4 = *(int*) t3; // get value of A[m]
    if ((int) s5 == (int) t4) goto conditionone;

    // else of (x == A[m])
    // if (x < A[m])
    if ((int) s5 < (int) t4) goto conditiontwo;

    // else of (s5 < t2)
    goto conditionthree;

    /* ------------------------------------------------------ */

    conditionone:

    // return m;
    a0 = s3;

    goto restorestack;

    /* ------------------------------------------------------ */

    conditiontwo:

    // return binary_search(A, low, m - 1, x);
    a2 = s1; // set low
    a3 = s3 - 1; // set high
    binary_search();
    goto restorestack;

    /* ------------------------------------------------------ */

    conditionthree:

    // return binary_search(A, m + 1, high, x);
    a2 = s3 + 1;
    a3 = s2;
    binary_search();
    goto restorestack;

    /* ------------------------------------------------------ */

    conditionfour:

    // return low + 1;
    a0 = s1 + 1;
    goto restorestack;

    /* ------------------------------------------------------ */

    conditionfive:

    // return low;
    a0 = s1;
    goto restorestack;

    /* ------------------------------------------------------ */

    restorestack:

    s5 = stacked_s5;
    s4 = stacked_s4;
    s3 = stacked_s3;
    s2 = stacked_s2;
    s1 = stacked_s1;
    return;

    /* ------------------------------------------------------ */
}


// void insertion_sort(int* A, int size)
void insertion_sort() {

    // VARIABLES
    // A = a0 / s6
    // size = a1 / s7
    // 0 = a2 (low)
    // j = a3 (high) / t5 / s5
    // x = a4 (x) / s4
    // i = t0
    // idx = t1

    // stack values
    size_t stacked_s4 = s4;
    size_t stacked_s5 = s5;
    size_t stacked_s6 = s6;
    size_t stacked_s7 = s7;

    // store variables
    s6 = a0;
    s7 = a1;

    // int i = 0;
    t0 = zero;
    // int x = 0;
    s4 = zero;
    // int idx = 0;
    t1 = zero;

    // for (int j = 1; j < size; j++)
    s5 = 1; // int j = 1
    forloophead:
    if ((int) s5 < (int) s7) goto forloopinner; // (j < size)

    // restore stack
    s7 = stacked_s7;
    s6 = stacked_s6;
    s5 = stacked_s5;
    s4 = stacked_s4;

    return;

    /* ------------------------------------------------------ */
    /* ------------------------------------------------------ */

    forloopinner:

    // x = A[j];
    // t2 = a3 * sizeof(int); // size of step
    t4 = 2;
    t2 = s5 << t4;
    t3 = s6 + t2; // pointer increment to get address of A[j]
    s4 = *(int*) t3;

    // idx = binary_search(A, 0, j, x);
    // return variable is a0
    a2 = zero;
    a3 = s5;
    a4 = s4;
    binary_search();

    // store idx correctly
    t1 = a0; // idx = returnvalue

    // i = j;
    t0 = s5;

    whileloophead:
    // while (i > idx) = (idx < i)
    if ((int) t1 < (int) t0) goto whileloopinner;

    // A[idx] = x;
    // t2 = t1 * sizeof(int); // increment for address
    t4 = 2;
    t2 = t1 << t4;
    t3 = s6 + t2; // actual address
    *(int*) t3 = s4;

    // j++
    s5 = s5 + 1;

    // restore a0
    a0 = s6;

    goto forloophead;

    /* ------------------------------------------------------ */

    whileloopinner:

    // A[i] = A[i - 1];
    // t2 = t0 * sizeof(int); // increment for address
    t4 = 2;
    t2 = t0 << t4;

    t3 = s6 + t2; // actual address of A[i]
    t4 = t3 - sizeof(int); // actual address of A[i-1]
    *(int*) t3 = *(int*) t4;

    // i--;
    t0 = t0 - 1;

    goto whileloophead;

    /* ------------------------------------------------------ */
}


void input(void) {
    // Read size
    t0 = a0; // Save a0
    a0 = fscanf(stdin, "%08x\n", (int*) &t1);
    t4 = 1;
    if (a0 == t4) goto input_continue;
    // Early exit
    a0 = 0;
    return;

    input_continue:
    t4 = 1;
    t5 = 10;
    input_loop_begin:
    if (t5 == 0) goto after_input_loop;
    a0 = fscanf(stdin, "%08x\n", (int*) &t2);
    if (a0 == t4) goto continue_read;
    // Exit, because read was not successful
    a0 = t1;
    return;
    continue_read:
    *(int*) t0 = t2;
    // Pointer increment for next iteration
    t0 = t0 + 4;
    // Loop counter decrement
    t5 = t5 - 1;
    goto input_loop_begin;

    after_input_loop:
    a0 = t1;
    return;
}


void output(void) {
    before_output_loop:
    if (a0 == 0) goto after_output_loop;

    fprintf(stdout, "%08x\n", (unsigned int) *(int*) a1);

    // Pointer increment for next iteration
    a1 = a1 + 4;
    // Decrement loop counter
    a0 = a0 - 1;
    goto before_output_loop;

    after_output_loop:
    return;
}


int main(void) {
    int A[10];
    int size;

    a0 = (size_t) A;
    input();
    size = a0;

    a0 = (size_t) A;
    a1 = size;
    // void insertion_sort(int* A, int size)
    insertion_sort();

    a0 = size;
    a1 = (size_t) A;
    output();

    return 0;
}


