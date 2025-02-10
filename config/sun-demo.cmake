message("--------> Enter sun-demo.cmake")
# Block #1: Set CXX compiler flag
if (NOT CMAKE_BUILD_TYPE STREQUAL "None") # 表示当前的CMAKE_BUILD_TYPE的值不为None
    message("CMAKE_BUILD_TYPE is not none")
endif()


if (ASDF) # 表示
    message("ASDF is define")
else(ASDF)
    message("ASDF is not defined")
endif()

if (NOT ASDF2 STREQUAL "None")
    message("ASDF2 is define")
else(NOT ASDF2 STREQUAL "None")
    message("ASDF2 is not defined")
endif()

if(CMAKE_BUILD_TYPE)
    message(status "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
else(NOT CMAKE_BUILD_TYPE)
    message(status "CMAKE_BUILD_TYPE: ")
endif()



# ---
# # 定义一个包含版本号的字符串变量
# SET(VERSION "1.2.3-beta")

# # 我们想要将 "-beta" 替换为 "-release"
# STRING(REPLACE "-beta" "-release" UPDATED_VERSION "${VERSION}")

# 输出替换后的版本号，注释
# MESSAGE(STATUS "Original version: ${VERSION}")
# MESSAGE(VERBOSE " Original version: ${VERSION}")
# MESSAGE(DEBUG " Original version: ${VERSION}")
# MESSAGE(TRACE " Original version: ${VERSION}")

# MESSAGE(WARNING " Original version: ${VERSION}")
# MESSAGE(AUTHOR_WARNING " Original version: ${VERSION}")
# MESSAGE(DEPRECATION " Original version: ${VERSION}")

# MESSAGE(SEND_ERROR " SEND_ERROR")
# MESSAGE(FATAL_ERROR " FATAL_ERROR")

# MESSAGE( "Updated version: ${UPDATED_VERSION}")

# SET(ENV{GLOBAL_LIBRARY_SRCS})

# ---
# 在 CMake 项目中创建自定义的缓存变量，
# 用于存储额外的 C 语言编译标志（CMAKE_C_FLAGS_ADD）和链接标志（CMAKE_LD_FLAGS_ADD），
# 方便用户根据项目需求灵活添加额外的编译和链接选项。

# 创建额外的编译和链接标志缓存变量
# SET ( CMAKE_C_FLAGS_ADD "${CMAKE_C_FLAGS}"  CACHE STRING "Specify here your additional C flags.")
# SET ( CMAKE_LD_FLAGS_ADD "${CMAKE_LD_FLAGS}"  CACHE STRING "Specify here your additional link flags.")

# # 将额外的编译和链接标志添加到默认标志中
# SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_ADD}")
# SET(CMAKE_LD_FLAGS "${CMAKE_LD_FLAGS} ${CMAKE_LD_FLAGS_ADD}")

# # 添加可执行文件
# add_executable(MyExecutable main.c)

message("<-------- Enter sun-demo.cmake")