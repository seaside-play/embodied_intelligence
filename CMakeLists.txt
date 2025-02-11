cmake_minimum_required(VERSION 3.1)

project(sun)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SUN_TARGET "gnulinux" CACHE STRING "Specify the platform" FORCE)

SET(PROJECT_SOURCE_DIR ${sun_SOURCE_DIR}) # 这个源码的目录
SET(PROJECT_BINARY_DIR ${sun_BINARY_DIR}) # 这个是build的目录

message(STATUS "PROJECT_SOURCE_DIR ${PROJECT_SOURCE_DIR}")
message(STATUS "PROJECT_BINARY_DIR ${PROJECT_BINARY_DIR}")

include(config/sun_macros.cmake)

add_subdirectory(src)
add_subdirectory(test)