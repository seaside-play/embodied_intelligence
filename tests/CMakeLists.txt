# 要想使用测试用例，需要在src中打开这个开关，以便src所产生的so文件，能够在tests中使用到
option(ENABLE_TEST "enable test" OFF)
if(ENABLE_TEST)
  # enable_testing()

  file(GLOB SRCS [^.]*.cpp)
  file(GLOB HPPS [^.]*.hpp)

  add_executable(tests ${SRCS})

  target_link_libraries(tests PRIVATE sun_dynamic)
  target_include_directories(tests PRIVATE BEFORE ${CMAKE_SOURCE_DIR}/src/packfiles/gtest/include)
  target_include_directories(tests PRIVATE BEFORE ${CMAKE_SOURCE_DIR}/src/sun/earth)
  
  target_link_libraries(tests PRIVATE ${CMAKE_SOURCE_DIR}/src/packfiles/gtest/lib/libgtest.a)
  target_link_libraries(tests PRIVATE ${CMAKE_SOURCE_DIR}/src/packfiles/gtest/lib/libgtest_main.a)
  target_link_libraries(tests PRIVATE pthread)

endif(ENABLE_TEST)