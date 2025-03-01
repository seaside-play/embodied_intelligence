#include <iostream>
#include "sun/earth/basic.hpp"

void TestCompileDefinition();

int main(int agrc, char** argv) {
    std::cout << "hello world!\n";

    std::cout << "3 + 2 = " << Add(3, 2) << std::endl;

    TestCompileDefinition();

    return 0;
}

void TestCompileDefinition() {
#ifdef SUN_TARGET
    std::cout << "SUN_TARGET is defined" << std::endl;
#else
    std::cout << "SUN_TARGET is not defined " << std::endl;
#endif


#if SUN_TARGET == gnulinux
    std::cout << "now is gunlinux\n";
#else
    std::cout << "now is not gunlinux\n";
#endif
}