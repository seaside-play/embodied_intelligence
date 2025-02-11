#include "basic.hpp"
#include <gtest/gtest.h>

// int main(int argc, char**argv) {
//     std::cout << "3 + 39 = " << Add(3, 39) << std::endl;
//     return 0;
// }

// 定义一个测试用例
TEST(AddTest, PositiveNumbers) {
    EXPECT_EQ(Add(2, 3), 5);
}

// 可以添加更多的测试用例
TEST(AddTest, NegativeNumbers) {
    EXPECT_EQ(Add(-2, -3), -5);
}
