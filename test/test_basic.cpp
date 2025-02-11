#include "basic.hpp"
#include <gtest/gtest.h>

// 定义一个测试用例
TEST(AddTest, PositiveNumbers) {
    EXPECT_EQ(Add(2, 3), 5);
}

// 可以添加更多的测试用例
TEST(AddTest, NegativeNumbers) {
    EXPECT_EQ(Add(-2, -3), -5);
}