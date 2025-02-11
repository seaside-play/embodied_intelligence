message("--------> Enter check_depend.cmake")

# 就是获取当前系统gnulinux的so的路径，并放入列表中。所谓依赖，就是第三方so的依赖已经对应的头文件的依赖。
# PROJECT_INCLUDE_DIRS和PROJECT_INCLUDE_LIBRARIES
# Modules path (for searching FindXXX.cmake files)
# CMAKE_MODULE_PATH为默认的库搜索路径列表
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/config)
message(STATUS "CMAKE_MODULE_PATH are ${CMAKE_MODULE_PATH}")

message("CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}")

include(${CMAKE_SOURCE_DIR}/config/SelectOneLibrary.cmake)

SET(CMAKE_VERSION "${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")
MESSAGE(STATUS "CMAKE_VERSION: ${CMAKE_VERSION}")


###########################################################
#                                                         #
# Some global options we need to set here                 #
#                                                         #
###########################################################
#
# STATIC or SHARED
#
OPTION( BUILD_STATIC "Build Orocos RTT as a static library." ${FORCE_BUILD_STATIC})
#
# CORBA
#
OPTION( ENABLE_CORBA "Enable CORBA" OFF)
IF (NOT CORBA_IMPLEMENTATION)
  SET( CORBA_IMPLEMENTATION "TAO" CACHE STRING "The implementation of CORBA to use (allowed values: TAO or OMNIORB )" )
ELSE(NOT CORBA_IMPLEMENTATION)
  SET( CORBA_IMPLEMENTATION ${CORBA_IMPLEMENTATION} CACHE STRING "The implementation of CORBA to use (allowed values: TAO or OMNIORB )" )
ENDIF (NOT CORBA_IMPLEMENTATION)
#
# CORBA Remote OperationCallers in C++
#
OPTION( ORO_REMOTING "Enable transparant Remote OperationCallers Calls in C++" ON )
# Force remoting when CORBA is enabled.
IF ( ENABLE_CORBA AND NOT ORO_REMOTING )
  MESSAGE( "Forcing ORO_REMOTING to ON")
  SET( ORO_REMOTING ON CACHE BOOL "Enable transparant Remote OperationCallers and Commands in C++" FORCE)
ENDIF( ENABLE_CORBA AND NOT ORO_REMOTING )

# Is modified by target selection below
OPTION(OS_NO_ASM "Do not use any assembler instruction, but stick to ISO C++ as much as possible. This will exclude lock-free and atomic algorithms." OFF )
if (OS_NO_ASM AND Boost_VERSION LESS 103600)
  message(SEND_ERROR "OS_NO_ASM was turned on, but this requires Boost v1.36.0 or newer.")
endif()

OPTION(PLUGINS_ENABLE "Enable plugins" ON)
OPTION(PLUGINS_STD_TYPES_SUPPORT "Enable support for the std::string and std::vector<double> types in the RTT typekit & transports." ON)

###########################################################
#                                                         #
# Look for dependencies required by individual components #
#                                                         #
###########################################################

# Look for boost We look up all components in one place because this macro does
# not support multiple invocations in some CMake versions.
# 会自动打印要查找的库文件以及查找的结果,find_package就是查找so文件，若是能够找到，就可以包含对应的so文件以及头文件
# 规则：Boost是库的名字，每个库都需要一个名字来标识
# 每个库中会有很多的组件，使用COMPONENTS来表示
# 当使用find_package查找Boost库时，CMake通常会使用名为FindBoost.cmake的模块。
# 该模块具有复杂的逻辑来处理不同版本的Boost库和不同的组件。
message(STATUS "0")
find_package(Boost 1.38 COMPONENTS filesystem system unit_test_framework thread serialization regex chrono)
message(STATUS "1")
# Look for boost
if(PLUGINS_ENABLE)
  if (NOT Boost_FILESYSTEM_FOUND OR NOT Boost_SYSTEM_FOUND)
    message(SEND_ERROR "Plugins require Boost Filesystem and System libraries, but they were not found.")
  endif()
  list(APPEND OROCOS-RTT_INCLUDE_DIRS ${Boost_FILESYSTEM_INCLUDE_DIRS} ${Boost_SYSTEM_INCLUDE_DIRS} ${Boost_THREAD_INCLUDE_DIRS} ${Boost_SERIALIZATION_INCLUDE_DIRS} ${Boost_REGEX_INCLUDE_DIRS} ${Boost_CHRONO_INCLUDE_DIRS})
  message(STATUS "include_dirs ${Boost_FILESYSTEM_INCLUDE_DIRS} ${Boost_SYSTEM_INCLUDE_DIRS} ${Boost_THREAD_INCLUDE_DIRS} ${Boost_SERIALIZATION_INCLUDE_DIRS} ${Boost_REGEX_INCLUDE_DIRS} ${Boost_CHRONO_INCLUDE_DIRS}")
  list(APPEND OROCOS-RTT_LIBRARIES ${Boost_FILESYSTEM_LIBRARIES} ${Boost_SYSTEM_LIBRARIES} ${Boost_THREAD_LIBRARIES} ${Boost_SERIALIZATION_LIBRARIES} ${Boost_REGEX_LIBRARIES} ${Boost_CHRONO_LIBRARIES})
  message(STATUS "libraries ${Boost_FILESYSTEM_LIBRARIES} ${Boost_SYSTEM_LIBRARIES} ${Boost_THREAD_LIBRARIES} ${Boost_SERIALIZATION_LIBRARIES} ${Boost_REGEX_LIBRARIES} ${Boost_CHRONO_LIBRARIES}")
endif()

if(Boost_INCLUDE_DIR) # 添加_INCLUDE_DIR就是对应库的头文件，有FindBoost.cmake来解决如何定义和设置对应的变量名
  message("Boost found in ${Boost_INCLUDE_DIR}")
  list(APPEND OROCOS-RTT_INCLUDE_DIRS ${Boost_INCLUDE_DIR})
  message(STATUS "SUN_TARGET ${SUN_TARGET}")
  if(SUN_TARGET STREQUAL "win32")
    add_definitions(-DBOOST_ALL_NO_LIB)
  endif()
  # We don't link with boost here. It depends on the options set by the user.
  #list(APPEND OROCOS-RTT_LIBRARIES ${Boost_LIBRARIES} )
else(Boost_INCLUDE_DIR)
  message(FATAL_ERROR "Boost_INCLUDE_DIR not found ! Add it to your CMAKE_PREFIX_PATH !")
endif(Boost_INCLUDE_DIR)

# Look for linux capabilities (7)
find_library(LINUX_CAP_NG_LIBRARY cap-ng)

# Look for Xerces 

# If a nonstandard path is used when crosscompiling, uncomment the following lines
# IF(NOT CMAKE_CROSS_COMPILE) # NOTE: There now exists a standard CMake variable named CMAKE_CROSSCOMPILING
#   set(XERCES_ROOT_DIR /path/to/xerces CACHE INTERNAL "" FORCE) # you can also use set(ENV{XERCES_ROOT_DIR} /path/to/xerces)
# ENDIF(NOT CMAKE_CROSS_COMPILE)

OPTION(OROBLD_FORCE_TINY_DEsunHALLER "Force usage of TinyDesunhaller." ON)

IF (NOT OROBLD_FORCE_TINY_DEsunHALLER)
  find_package(Xerces)
ENDIF (NOT OROBLD_FORCE_TINY_DEsunHALLER)

if(XERCES_FOUND)
  set(OROPKG_SUPPORT_XERCES_C TRUE CACHE INTERNAL "" FORCE)
  list(APPEND OROCOS-RTT_INCLUDE_DIRS ${XERCES_INCLUDE_DIRS} )
  list(APPEND OROCOS-RTT_LIBRARIES ${XERCES_LIBRARIES} ) 
  set(ORODAT_CORELIB_PROPERTIES_sunHALLING_INCLUDE "\"sunh/CPFsunhaller.hpp\"")
  set(OROCLS_CORELIB_PROPERTIES_sunHALLING_DRIVER "CPFsunhaller")
  set(ORODAT_CORELIB_PROPERTIES_DEsunHALLING_INCLUDE "\"sunh/CPFDesunhaller.hpp\"")
  set(OROCLS_CORELIB_PROPERTIES_DEsunHALLING_DRIVER "CPFDesunhaller")
else(XERCES_FOUND)
  set(OROPKG_SUPPORT_XERCES_C FALSE CACHE INTERNAL "" FORCE)
  set(ORODAT_CORELIB_PROPERTIES_sunHALLING_INCLUDE "\"sunh/CPFsunhaller.hpp\"")
  set(OROCLS_CORELIB_PROPERTIES_sunHALLING_DRIVER "CPFsunhaller")
  set(ORODAT_CORELIB_PROPERTIES_DEsunHALLING_INCLUDE "\"sunh/TinyDesunhaller.hpp\"")
  set(OROCLS_CORELIB_PROPERTIES_DEsunHALLING_DRIVER "TinyDesunhaller")
endif(XERCES_FOUND)

# Check for OS/Target specific dependencies:
message("Orocos target is ${SUN_TARGET}")
string(TOUPPER ${SUN_TARGET} SUN_TARGET_CAP)

# Setup flags for Xenomai
if(SUN_TARGET STREQUAL "xenomai")
  set(OROPKG_OS_XENOMAI TRUE CACHE INTERNAL "This variable is exported to the rtt-config.h file to expose our target choice to the code." FORCE)
  set(OS_HAS_TLSF TRUE)

  find_package(Xenomai REQUIRED)
  find_package(Pthread REQUIRED)
  find_package(XenomaiPosix)

  add_definitions( -Wall )

  if(XENOMAI_FOUND)
    list(APPEND OROCOS-RTT_USER_LINK_LIBS ${XENOMAI_LIBRARIES} ) # For libraries used in inline (fosi/template) code.
    list(APPEND OROCOS-RTT_INCLUDE_DIRS ${XENOMAI_INCLUDE_DIRS} ${PTHREAD_INCLUDE_DIRS})
    list(APPEND OROCOS-RTT_LIBRARIES ${XENOMAI_LIBRARIES} ${PTHREAD_LIBRARIES} dl) 
    list(APPEND OROCOS-RTT_DEFINITIONS "SUN_TARGET=${SUN_TARGET}") 
    if (XENOMAI_POSIX_FOUND)
      set(MQ_LDFLAGS ${XENOMAI_POSIX_LDFLAGS} )
      set(MQ_CFLAGS ${XENOMAI_POSIX_CFLAGS} )
      set(MQ_INCLUDE_DIRS ${XENOMAI_POSIX_INCLUDE_DIRS})
      set(MQ_LIBRARIES ${XENOMAI_POSIX_LIBRARIES})
    endif()
  endif()
else()
  set(OROPKG_OS_XENOMAI FALSE CACHE INTERNAL "" FORCE)
endif()

# Setup flags for GNU/Linux
# INTERNAL 指定变量的类型为内部变量。
# 内部变量通常是供 CMake 脚本内部使用的，
# 不会在 CMake 的图形界面工具（像 ccmake 或者 CMake GUI）中显示，也不希望用户手动修改。
if(SUN_TARGET STREQUAL "gnulinux")  
  set(OROPKG_OS_GNULINUX TRUE CACHE INTERNAL "This variable is exported to the rtt-config.h file to expose our target choice to the code." FORCE)
  set(OS_HAS_TLSF TRUE)

  find_package(Boost 1.36 COMPONENTS thread)
  message(STATUS "--- begin to find_package(Pthread REQUIRED)")
  message(STATUS "--- CMAKE_MODULE_PATH is ${CMAKE_MODULE_PATH}")
  # message(STATUS "--- CMAKE_PREFIX_PATH is ${CMAKE_PREFIX_PATH}")
  
  # CMake 自带调试模式，开启后能输出更多查找过程的详细信息。
  # 可以通过设置 CMAKE_FIND_DEBUG_MODE 变量为 ON 来开启调试模式。
  # message(STATUS "set(CMAKE_FIND_DEBUG_MODE ON)")
  set(CMAKE_FIND_DEBUG_MODE ON) 
  # find_package(Pthread REQUIRED)
  # message("find pthread lib : ${PTHREAD_LIBRARIES}")
  # message("find pthread header: ${PTHREAD_INCLUDE_DIRS}")
  add_definitions( -Wall )

  list(APPEND OROCOS-RTT_INCLUDE_DIRS ${PTHREAD_INCLUDE_DIRS})
  list(APPEND OROCOS-RTT_USER_LINK_LIBS ${PTHREAD_LIBRARIES} rt) # For libraries used in inline (fosi/template) code.

  list(APPEND OROCOS-RTT_LIBRARIES ${PTHREAD_LIBRARIES} rt dl) 
  list(APPEND OROCOS-RTT_DEFINITIONS "SUN_TARGET=${SUN_TARGET}") 
else()
  set(OROPKG_OS_GNULINUX FALSE CACHE INTERNAL "" FORCE)
endif()

if(SUN_TARGET STREQUAL "win32")
  set(OROPKG_OS_WIN32 TRUE CACHE INTERNAL "" FORCE)
  message("Forcing OS_HAS_TLSF to OFF for WIN32")
  set(OS_HAS_TLSF FALSE)
  # Force OFF on mqueue transport on WIN32 platform
  message("Forcing ENABLE_MQ to OFF for WIN32")
  set(ENABLE_MQ OFF CACHE BOOL "This option is forced to OFF by the build system on WIN32 platform." FORCE)
  if (MINGW)
    #--enable-all-export and --enable-auto-import are already set by cmake.
    #but we need it here for the unit tests as well.
    set(CMAKE_SHARED_LINKER_FLAGS "-Wl,--enable-auto-import -Wl,--export-all-symbols")
    set(CMAKE_EXE_LINKER_FLAGS "-Wl,--enable-auto-import")
    list(APPEND OROCOS-RTT_LIBRARIES wsock32.lib winmm.lib)
  endif()
  if (MSVC)
    if (NOT MSVC80)
        set(NUM_PARALLEL_BUILD 4 CACHE STRING "Number of parallel builds")
        set(PARALLEL_FLAG "/MP${NUM_PARALLEL_BUILD}")
    endif()
    set(CMAKE_CXX_FLAGS_ADD "/wd4355 /wd4251 /wd4180 /wd4996 /wd4250 /wd4748 /bigobj /Oi ${PARALLEL_FLAG}")
    list(APPEND OROCOS-RTT_LIBRARIES kernel32.lib user32.lib gdi32.lib winspool.lib shell32.lib  ole32.lib oleaut32.lib uuid.lib comdlg32.lib advapi32.lib Ws2_32.lib winmm.lib)
  endif()
  list(APPEND OROCOS-RTT_DEFINITIONS "SUN_TARGET=${SUN_TARGET}") 
  set(CMAKE_DEBUG_POSTFIX "d")
else(SUN_TARGET STREQUAL "win32")
  set(OROPKG_OS_WIN32 FALSE CACHE INTERNAL "" FORCE)
endif(SUN_TARGET STREQUAL "win32")

if( NOT OROCOS-RTT_DEFINITIONS )
  message(FATAL_ERROR "No suitable SUN_TARGET selected. Use one of 'lxrt,xenomai,gnulinux,macosx,win32'")
endif()

# The machine type is tested using compiler macros in rtt-config.h.in
# Add found include dirs.
# INCLUDE_DIRECTORIES 是 CMake 中的一个命令，用于向项目的编译环境添加头文件搜索路径
# 通过使用list(APPEND OROCOS-RTT_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})来添加所有可能需要包含的头文件路径
# 之后使用incldue_directories来完成编译头文件的添加，正解
include_directories(${OROCOS-RTT_INCLUDE_DIRS})

#
# Disable line wrapping for g++ such that eclipse can parse the errors.
#
# CMAKE_COMPILER_IS_GNUCXX就是gnu的g++编译器
# 在现代 CMake 中，推荐使用 CMAKE_CXX_COMPILER_ID 来检测编译器类型，而不是依赖 CMAKE_COMPILER_IS_GNUCXX。
# CMAKE_CXX_COMPILER_ID 是一个更通用的变量，可以识别多种编译器。
# CMAKE_CXX_COMPILER_ID 的可能值包括：
#   GNU：GNU 编译器（g++）。
#   Clang：LLVM Clang 编译器。
#   MSVC：Microsoft Visual C++ 编译器。
#   Intel：Intel C++ 编译器。
# 示例
# if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
#     # 如果是 GNU 编译器
#     # 开启 -Wall 选项后，编译器会检查并报告多种类型的潜在问题，例如：
#     # -Wextra 选项会开启比 -Wall 更多的额外警告信息。
#     # 它会检查一些 -Wall 没有涵盖的、相对更细微的代码问题，提供更严格的代码检查。
#     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
# endif()

IF(CMAKE_COMPILER_IS_GNUCXX)
  # -fmessage-length 选项用于控制编译器输出的诊断信息（如警告和错误信息）的行长。
  # message-length=0 表示不折行，当行输出
  SET(CMAKE_CXX_FLAGS_ADD "${CMAKE_CXX_FLAGS_ADD} -fmessage-length=0")
ENDIF(CMAKE_COMPILER_IS_GNUCXX)

#
# If we're using gcc, make sure the version is OK.
#
IF (CMAKE_COMPILER_IS_GNUCXX)
  # this is a workaround distcc:
  IF ( CMAKE_CXX_COMPILER_ARG1 )
    STRING(REPLACE " " "" CMAKE_CXX_COMPILER_ARG1 ${CMAKE_CXX_COMPILER_ARG1} )
    #MESSAGE("Invoking: '${CMAKE_CXX_COMPILER_ARG1} -dumpversion'")
    EXECUTE_PROCESS( COMMAND ${CMAKE_CXX_COMPILER_ARG1} -dumpversion RESULT_VARIABLE CXX_HAS_VERSION OUTPUT_VARIABLE CXX_VERSION)
  ELSE ( CMAKE_CXX_COMPILER_ARG1 )
    #MESSAGE("Invoking: ${CMAKE_CXX_COMPILER} -dumpversion")
    EXECUTE_PROCESS( COMMAND ${CMAKE_CXX_COMPILER} -dumpversion RESULT_VARIABLE CXX_HAS_VERSION OUTPUT_VARIABLE CXX_VERSION)
  ENDIF ( CMAKE_CXX_COMPILER_ARG1 )

  IF ( ${CXX_HAS_VERSION} EQUAL 0 )
    # We are assuming here that -dumpversion is gcc specific.
    IF( CXX_VERSION MATCHES "4\\.[0-9](\\.[0-9])?" )
      MESSAGE(STATUS "Detected gcc4: ${CXX_VERSION}")
      SET(RTT_GCC_HASVISIBILITY TRUE)
    ELSE(CXX_VERSION MATCHES "4\\.[0-9](\\.[0-9])?")
      IF( CXX_VERSION MATCHES "3\\.[0-9](\\.[0-9])?" )
	MESSAGE(STATUS "Detected gcc3: ${CXX_VERSION}")
      ELSE( CXX_VERSION MATCHES "3\\.[0-9](\\.[0-9])?" )
	MESSAGE("ERROR: You seem to be using gcc version:")
	MESSAGE("${CXX_VERSION}")
	MESSAGE( FATAL_ERROR "ERROR: For gcc, Orocos requires version 4.x or 3.x")
      ENDIF( CXX_VERSION MATCHES "3\\.[0-9](\\.[0-9])?" )
    ENDIF(CXX_VERSION MATCHES "4\\.[0-9](\\.[0-9])?")
  ELSE ( ${CXX_HAS_VERSION} EQUAL 0)
    MESSAGE("Could not determine gcc version: ${CXX_HAS_VERSION}")
  ENDIF ( ${CXX_HAS_VERSION} EQUAL 0)
ENDIF()

#
# Set flags for code coverage, and setup coverage target
# 代码覆盖率是一种衡量代码被测试用例执行程度的指标
#
set(BUILD_ENABLE_COVERAGE OFF CACHE BOOL "COVERAGE" FORCE)
IF (BUILD_ENABLE_COVERAGE)

  FIND_PACKAGE(Lcov REQUIRED)

  # for required flags see
  # http://git.benboeckel.net/?p=chasmd.git;a=blob;f=CMakeLists.txt
  # http://www.cmake.org/Wiki/CTest:Coverage
  # man gcov

  # 这里的-profile-arcs和-ftest-coverage有什么作用？
  SET(CMAKE_CXX_FLAGS_ADD "${CMAKE_CXX_FLAGS_ADD} -g -O0 -fprofile-arcs -ftest-coverage")
  SET(CMAKE_C_FLAGS_ADD "${CMAKE_C_FLAGS_ADD} -g -O0 -fprofile-arcs -ftest-coverage")
  SET(CMAKE_LD_FLAGS_ADD "${CMAKE_LD_FLAGS_ADD} -fprofile-arcs -ftest-coverage")

  # coverage
  ADD_CUSTOM_TARGET(coverage)
  ADD_CUSTOM_COMMAND(TARGET coverage
    COMMAND mkdir -p coverage
    COMMAND ${LCOV_LCOV_EXECUTABLE} --directory . --zerocounters
    COMMAND make check
	# all coverage data
    COMMAND ${LCOV_LCOV_EXECUTABLE} --directory . --capture --output-file ./coverage/all.info
	# RTT-only coverage data
    COMMAND ${LCOV_LCOV_EXECUTABLE} --output-file ./coverage/rtt.info -e ./coverage/all.info '${CMAKE_SOURCE_DIR}/*'
	# generate based on RTT-only data
    COMMAND ${LCOV_GENHTML_EXECUTABLE} -t "Orocos RTT coverage" -p "${CMAKE_SOURCE_DIR}"  -o ./coverage ./coverage/rtt.info
    COMMAND echo "Open ${CMAKE_BINARY_DIR}/coverage/index.html to view the coverage analysis results."
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    )
  # todo dependancy of coverage on test?
  message(STATUS "************ use coverage")
else(BUILD_ENABLE_COVERAGE)
  message(STATUS "************ don't use coverage")
  
ENDIF (BUILD_ENABLE_COVERAGE)

#
# Check for Doxygen and enable documentation building
#
# find_package( Doxygen )
# IF ( DOXYGEN_EXECUTABLE )
#   MESSAGE( STATUS "Found Doxygen -- API documentation can be built" )
# ELSE ( DOXYGEN_EXECUTABLE )
#   MESSAGE( STATUS "Doxygen not found -- unable to build documentation" )
# ENDIF ( DOXYGEN_EXECUTABLE )

# if(DOXYGEN_FOUND)
#     # 设置 Doxygen 配置文件路径
#     set(DOXYGEN_IN ${CMAKE_SOURCE_DIR}/Doxyfile.in)
#     set(DOXYGEN_OUT ${CMAKE_BINARY_DIR}/Doxyfile)

#     # 配置 Doxygen 配置文件
#     configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)

#     # 添加自定义目标来生成文档
#     add_custom_target( doc_doxygen ALL
#         COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
#         WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
#         COMMENT "Generating API documentation with Doxygen"
#         VERBATIM )
# else(DOXYGEN_FOUND)
#     message("Doxygen need to be installed to generate the doxygen documentation")
# endif(DOXYGEN_FOUND)

list(APPEND OROCOS-RTT_INCLUDE_DIRS /usr/local/include)

#
# Detect CORBA using user's CORBA_IMPLEMENTATION
#
# find_package(Corba REQUIRED)
#
# Detect rkd lib
#
#find_package(Arcs-Rkd REQUIRED)
#if(Arcs-Rkd_FOUND)
#  list(APPEND OROCOS-RTT_INCLUDE_DIRS ${Arcs-Rkd_INCLUDE_DIRS})
#  list(APPEND OROCOS-RTT_LIBRARIES ${Arcs-Rkd_LIBRARY_DIRS}/lib${Arcs-Rkd_LIBRARIES}.so) 
#endif()
list(APPEND OROCOS-RTT_LIBRARIES ${PROJ_SOURCE_DIR}/src/packfiles/x86-lib/libarcs-rkd.so) 
list(APPEND OROCOS-RTT_LIBRARIES ${PROJ_SOURCE_DIR}/src/packfiles/x86-lib/libRkdInterface.so)
list(APPEND OROCOS-RTT_LIBRARIES ${PROJ_SOURCE_DIR}/src/packfiles/x86-lib/libmodbus.so)
list(APPEND OROCOS-RTT_LIBRARIES ${PROJ_SOURCE_DIR}/src/packfiles/x86-lib/libmelsec.so)
list(APPEND OROCOS-RTT_LIBRARIES ${PROJ_SOURCE_DIR}/src/packfiles/x86-lib/libeip_sdk.so)
#
#add RCF lib
#
list(APPEND OROCOS-RTT_LIBRARIES ${PROJ_SOURCE_DIR}/src/packfiles/x86-lib/libRCF.so) 
#add sqlite lib 20170626pang
list(APPEND OROCOS-RTT_LIBRARIES /usr/local/lib/libsqlite3.so) 


#
#add log4cpp liyuan 20170629
#
list(APPEND OROCOS-RTT_LIBRARIES /usr/local/lib/liblog4cpp.so)

#
#add ros lib
#
#if ros find,add ros lib link
IF(ENABLE_ROS)
find_package(catkin REQUIRED COMPONENTS
	roscpp
	rospy
	std_msgs
)
list(APPEND OROCOS-RTT_INCLUDE_DIRS  ${catkin_INCLUDE_DIRS})
list(APPEND OROCOS-RTT_LIBRARIES ${catkin_LIBRARIES} ) 
ENDIF(ENABLE_ROS)


message("<-------- Enter check_depend.cmake")