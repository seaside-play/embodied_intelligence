macro(GLOBAL_ADD_INCLUDE COMPONENT_LOCATION)
  install(FILES ${ARGN} DESTINATION include/${COMPONENT_LOCATION} COMPONENT headers)
endmacro(GLOBAL_ADD_INCLUDE COMPONENT_LOCATION)

# 创建GLOBAL_ADD_INCLUDE宏，并且使用${ARGN}实现多余参数的的指定
# 使用make install，执行cmake中的install命令，学得一招

macro(GLOBAL_ADD_SRC)
  string(LENGTH "${ARGN}" NOTEMPTY) # ${ARGN}表示各个参数
  message(STATUS "ARGN is ${ARGN}")
  if(NOTEMPTY) # 表示NOTEMPTY有定义且有值
    message(STATUS "1. $ENV{GLOBAL_LIBRARY_SRCS}")
    set(ENV{GLOBAL_LIBRARY_SRCS} "$ENV{GLOBAL_LIBRARY_SRCS}${ARGN};") # 注意需要使用;隔开
    message(STATUS "2. $ENV{GLOBAL_LIBRARY_SRCS}")
  endif(NOTEMPTY) 
endmacro(GLOBAL_ADD_SRC)