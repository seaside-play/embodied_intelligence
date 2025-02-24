add_subdirectory(earth)

add_library(sun_dynamic SHARED $ENV{GLOBAL_LIBRARY_SRCS})

# set_target_properties(sun_dynamic PROPERTIES 
# #   COMPILE_DEFINITIONS SUN_TARGET=${SUN_TARGET} # 可以实现执行跨平台选择
# #   COMPILE_FLAGS "-std=c++0x"
# # )