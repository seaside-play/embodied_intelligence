#include "io_state.hpp"
#include <gtest/gtest.h>

TEST(IoStateTest, SetTrue) {
    jdf::IOState::GetInstance().io_in_effect(true);
    EXPECT_TRUE(jdf::IOState::GetInstance().io_in_effect());
}