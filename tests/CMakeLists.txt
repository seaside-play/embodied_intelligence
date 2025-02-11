# 要想使用测试用例，需要在src中打开这个开关，以便src所产生的so文件，能够在tests中使用到
if(ENABLE_TESTS)
  enable_testing()

  message(STATUS "===============tests====================")

  include_directories(BEFORE ${PROJECT_SOURCE_DIR}/src/sun/earth)
  file(GLOB SRCS [^.]*.cpp)
  file(GLOB HPPS [^.]*.hpp)

  add_executable(sun_tests ${SRCS})
  target_link_libraries(sun_tests sun_dynamic)

endif(ENABLE_TESTS)