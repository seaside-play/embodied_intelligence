# 1 方法一
- googletest-release-1.8.1.tar.gz
- cmake
- sudo make install

可以直接在cmake中使用  target_link_libraries(tests gtest gtest_main pthread)

# 2 方法二

直接使用源代码,优点省事，缺点每次都要编译，影响编译速度

    add_subdirectory(googletest)
    set(LIBRARIES gtest gtest_main pthread)
    add_executable(test test.cpp)
    target_link_libraries(test ${LIBRARIES
    })


# 3 方法三

直接使用编译生成的a文件，googletest-release-1.8.1，默认编译时生成.a文件



