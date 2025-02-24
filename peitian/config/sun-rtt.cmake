# .cmake就是独立的类文件
# Block #1: Set build type
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif()

message("Setting build type to ${CMAKE_BUILD_TYPE}")
message("Debug means: ${CMAKE_CXX_FLAGS_DEBUG}")
message("Release means: ${CMAKE_CXX_FLAGS_RELEASE}")
message("RelWithDebInfo means: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
