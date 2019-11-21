enable_testing()

# Extra code that we use in tests
add_library(wdt4tests_min
      test/TestCommon.cpp
      )

include(ExternalProject)

# GTest
set(GTEST_PREFIX "${CMAKE_CURRENT_BINARY_DIR}/gtest")
externalproject_add(
      gtest
      GIT_REPOSITORY https://github.com/google/googletest.git
      INSTALL_COMMAND "" # Disable install step
      UPDATE_COMMAND "" # Doesn't change often
      PREFIX "${GTEST_PREFIX}"
      #CONFIGURE_COMMAND "" # skip
      #BUILD_COMMAND "" # skip
      LOG_DOWNLOAD ON
      LOG_CONFIGURE ON
      LOG_BUILD ON
)
# Specify include dir for gtest
externalproject_get_property(gtest SOURCE_DIR)
include_directories("${SOURCE_DIR}/googletest/include")

externalproject_get_property(gtest BINARY_DIR)

#  add_library(gmock_all STATIC EXCLUDE_FROM_ALL
#   ${GMOCK_PREFIX}/src/gmock/gtest/src/gtest-all.cc
#   ${GMOCK_PREFIX}/src/gmock/gmock-all.cc
#   ${GMOCK_PREFIX}/src/gmock/gmock_main.cc)

add_dependencies(wdt4tests_min gtest)

# ${BINARY_DIR}/libgtest.a works everywhere except xcode...
# so ugly weird hack generating warnings about unknown dir for now:
target_link_libraries(wdt4tests_min
      #"-L ${BINARY_DIR}/googlemock/gtest -L ${BINARY_DIR}/Debug -lgtest"
      "-L ${BINARY_DIR}/googlemock/gtest -lgtest"
      wdt_min
      )

add_library(wdt4tests
      ${WDT_FLAGS_RELATED_SRC}
      )
target_link_libraries(wdt4tests wdt4tests_min)

# TODO: make a macro/function to add tests in 1 line instead of 3


# WDT testing/benchmarking code
add_library(wdtbenchlib
      bench/Bigram.cpp
      )

target_link_libraries(wdtbenchlib
      ${GLOG_LIBRARY}
      ${GFLAGS_LIBRARY}
      )

add_library(wdtbenchtestslib
      bench/WdtGenTestUtils.cpp
      )
add_dependencies(wdtbenchtestslib gtest)
target_link_libraries(wdtbenchtestslib
      "-L ${BINARY_DIR}/googlemock/gtest -lgtest"
      wdtbenchlib
      ${CMAKE_THREAD_LIBS_INIT} # Must be last to avoid link errors
      )

add_executable(wdt_gen_files bench/wdtGenFiles.cpp)
target_link_libraries(wdt_gen_files wdtbenchlib
      ${CMAKE_THREAD_LIBS_INIT} # Must be last to avoid link errors
      )
set_target_properties(wdt_gen_files PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY "_bin/wdt/bench/")

add_executable(wdt_gen_stats bench/wdtStats.cpp)
target_link_libraries(wdt_gen_stats wdtbenchlib)

add_executable(wdt_gen_test bench/wdtGenTest.cpp)
target_link_libraries(wdt_gen_test wdtbenchtestslib)
add_test(NAME AllTestsInGenTest COMMAND wdt_gen_test)

# Regular tests

add_executable(protocol_test test/ProtocolTest.cpp)
target_link_libraries(protocol_test wdt4tests)
add_test(NAME AllTestsInProtocolTest COMMAND protocol_test)

add_executable(test_encdeci64_func test/test_encdeci64_func.cpp)
target_link_libraries(test_encdeci64_func wdt4tests)
add_test(NAME test_encdeci64_func COMMAND test_encdeci64_func)

add_executable(test_stats test/Stats_test.cpp)
target_link_libraries(test_stats wdt4tests)
add_test(NAME test_stats COMMAND test_stats)

add_executable(histogram test/Histogram.cpp)
target_link_libraries(histogram wdt_min)

add_executable(resource_controller_test  test/WdtResourceControllerTest.cpp)
target_link_libraries(resource_controller_test wdt4tests)
add_test(NAME ResourceControllerTests COMMAND resource_controller_test)

add_executable(wdt_url_test  test/WdtUrlTest.cpp)
target_link_libraries(wdt_url_test wdt4tests)
add_test(NAME WdtUrlTests COMMAND wdt_url_test)

add_executable(wdt_misc_tests  test/WdtMiscTests.cpp)
target_link_libraries(wdt_misc_tests wdt4tests)
add_test(NAME WdtMiscTests COMMAND wdt_misc_tests)

add_executable(wdt_fd_test  test/FdTest.cpp)
target_link_libraries(wdt_fd_test wdt4tests)
add_test(NAME WdtFdTests COMMAND wdt_fd_test)

add_executable(encryption_test  test/EncryptionTest.cpp)
target_link_libraries(encryption_test wdt4tests)
add_test(NAME EncryptionTests COMMAND encryption_test)

add_executable(file_reader_test  test/FileReaderTest.cpp)
target_link_libraries(file_reader_test wdt4tests)
add_test(NAME FileReaderTests COMMAND file_reader_test)

add_executable(option_type_test_long_flags test/OptionTypeTest.cpp)
target_link_libraries(option_type_test_long_flags wdt4tests)

add_executable(option_type_test_short_flags test/OptionTypeTest.cpp
      ${WDT_FLAGS_RELATED_SRC}
      )
set_target_properties(option_type_test_short_flags PROPERTIES
      COMPILE_DEFINITIONS "STANDALONE_APP"
      RUNTIME_OUTPUT_DIRECTORY "_bin/wdt/short_flags/")

target_link_libraries(option_type_test_short_flags wdt4tests_min)

add_test(NAME WdtRandGenTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_rand_gen_test.sh")

add_test(NAME WdtBasicE2E COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_e2e_simple_test.sh")

# Doesn't work on a mac:
#  add_test(NAME WdtStdinManifestAndUrl COMMAND
#    "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_stdin_test.sh")

add_test(NAME WdtLockFailFast COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_lock_failfast.sh")

add_test(NAME WdtBasicE2Exfs COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_e2e_xfs_test.sh")

add_test(NAME WdtOptionsTypeTests COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_option_type_test.sh")

add_test(NAME hostname_override_test COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/hostname_override_test.py")

add_test(NAME WdtPortBlockTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_port_block_test.py")

add_test(NAME WdtProtocolNegotiationTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_protocol_negotiation_test.py")

add_test(NAME WdtSimpleOdirectTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_e2e_simple_test.sh" -o true)

add_test(NAME WdtFileListTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_file_list_test.py")

add_test(NAME WdtOverwriteTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_overwrite_test.py")

add_test(NAME WdtBadServerTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_bad_server_test.py")

add_test(NAME ReceiverThrottlerRefCountTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/receiver_throttler_ref_count_test.sh")

add_test(NAME WdtLongRunningTest COMMAND
      "${CMAKE_CURRENT_SOURCE_DIR}/test/wdt_long_running_test.py")