# test script
include(${PROJECT_SOURCE_DIR}/config/sun-demo.cmake)
include(${PROJECT_SOURCE_DIR}/config/cxx-flags.cmake)

# Block #1: Set build type
if (NOT WIN32)
    include(${PROJECT_SOURCE_DIR}/config/sun-rtt.cmake OPTIONAL) # include .cmake文件路径即可
    if(NOT EXISTS ${PROJECT_SOURCE_DIR}/config/sun-rtt.cmake) # 判断文件是否存在
        message("No sun-rtt.cmake file loaded, using default settings."
                "See sun-rtt.default.cmake")
        include(${PROJECT_SOURCE_DIR}/config/sun-rtt.default.cmake)
    endif() # 可以接换endif
endif(NOT WIN32)

###################################################
#                                                 #
#       End project customization section         #
#                                                 #
###################################################

option(ENABLE_TESTS "Turn on to enable the testing framwork." OFF)
if(ENABLE_TESTS)
    # CTest 是 CMake 自带的一个测试框架，INCLUDE(CTest) 这行代码会引入 CTest 模块，从而把 CTest 相关的功能集成到当前的 CMake 项目中。
    include(CTest) # CTest是CMake自带的测试框架

    # 命令用于开启项目的测试功能。在调用这个命令之后，项目就可以使用 CMake 的测试相关命令（像 ADD_TEST）来定义和管理测试用例了。
    enable_testing()
endif()

# 该模块提供了一个名为 CMAKE_DEPENDENT_OPTION 的命令，用于创建依赖于其他选项的 CMake 选项。
# 这意味着一个选项的启用或禁用状态可以由另一个选项的值来决定，从而实现更灵活的配置选项管理。
# turn on code coverage of tests
include (CMakeDependentOption)
# 默认定义的BUILD_ENABLE_COVERAGE为OFF，它依赖于ENABLE_TESTS。仅当ENABLE_TESTS为ON时，BUILD_ENABLE_COVERAGE才开启。
CMAKE_DEPENDENT_OPTION(BUILD_ENABLE_COVERAGE "Turn on code coverage of all tests." OFF "ENABLE_TESTS" OFF)
if(BUILD_ENABLE_COVERAGE)
  # coverage requires test
  set(ENABLE_TESTS ON CACHE BOOL "" FORCE) # 确保了一致性
endif(BUILD_ENABLE_COVERAGE)

# 如果你的目标是确保C++编译器被正确配置和使用，你通常不需要做任何特别的事情，因为CMake会自动处理这些任务。
# 如果你需要指定编译器或提供额外的编译器标志，
# 你可以使用CMake提供的命令（如set(CMAKE_CXX_COMPILER ...)或add_compile_options(...)）来实现这一点。

# 示例
# 假设用户在CMake配置时运行：
# cmake -DBUILD_ENABLE_COVERAGE=ON ..
# BUILD_ENABLE_COVERAGE 被设为 ON。
# 由于 ENABLE_TESTS 是 BUILD_ENABLE_COVERAGE 的依赖项，代码会强制将 ENABLE_TESTS 设为 ON。

###################################################
#                                                 #
#       Do some global set-up & checking          #
#                                                 #
###################################################

# Find all installed libraries, compiler etc.
if(CROSS_COMPILE)
  include(check_cross_compile_depend.cmake)
else(CROSS_COMPILE)
  if(WIN32)
	  include(${PROJECT_SOURCE_DIR}/config/check_win_depend.cmake)
  else(WIN32)
	  include(${PROJECT_SOURCE_DIR}/config/check_depend.cmake) # ${CMAKE_SOURCE_DIR}等同与${PROJECT_SOURCE_DIR}
  endif(WIN32)
endif(CROSS_COMPILE)

add_subdirectory(sun) 

add_executable(main main.cpp)

#设置目标之间的构建顺序依赖关系, 在构建main之前，必须先构建完arcs_rtt_${SUN_TARGET}_dynamic
# add_dependencies(main sun_dynamic) # 确定构建的先后顺序
target_link_libraries(main sun_dynamic)