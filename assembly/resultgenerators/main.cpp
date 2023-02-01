#include <iostream>

// 2021-02-13
// result = 12
/*
int times3(int* p) {
    return *p * 3;
}

int main() {
    int a = 3;
    return a + times3(&a);
}
 */

// 2021-02-22
// result = 7
/*
int g;

int addglobal(int* p) {
    return *p + g;
}

int main() {
    int a = 3;
    g = 4;
    return addglobal(&a);
}
 */