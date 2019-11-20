#.rst:
#
# Adapted from https://github.com/omnisci/omniscidb/blob/master/cmake/Modules/FindFolly.cmake
# Carries the Apache 2.0 License
#
# FindFolly.cmake
# -------------
#
# Find a Folly installation.
#
# This module finds if Folly is installed and selects a default
# configuration to use.
#
# find_package(Folly ...)
#
# The following are set after the configuration is done:
#
# ::
#
#   FOLLY_FOUND            - Set to TRUE if Folly was found.
#   FOLLY_LIBRARIES        - Path to the Folly libraries.
#   FOLLY_LIBRARY_DIRS     - compile time link directories
#   FOLLY_INCLUDE_DIRS     - compile time include directories
#
#
# Sample usage:
#
# ::
#
#    find_package(Folly)
#    if(FOLLY_FOUND)
#      target_link_libraries(<YourTarget> ${FOLLY_LIBRARIES})
#    endif()

find_library(FOLLY_LIBRARY
        NAMES folly
        HINTS
        ENV LD_LIBRARY_PATH
        ENV DYLD_LIBRARY_PATH
        PATHS
        /usr/lib
        /usr/local/lib
        /usr/local/homebrew/lib
        /opt/local/lib)

get_filename_component(FOLLY_LIBRARY_DIR ${FOLLY_LIBRARY} DIRECTORY)

find_library(FOLLY_DC_LIBRARY
        NAMES double-conversion
        HINTS
        ENV LD_LIBRARY_PATH
        ENV DYLD_LIBRARY_PATH
        PATHS
        /usr/lib
        /usr/local/lib
        /usr/local/homebrew/lib
        /opt/local/lib)

find_package(OpenSSL REQUIRED)

if(FOLLY_USE_STATIC_LIBS)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_CMAKE_FIND_LIBRARY_SUFFIXES})
endif()

# Set standard CMake FindPackage variables if found.
set(FOLLY_LIBRARIES ${FOLLY_LIBRARY} ${FOLLY_DC_LIBRARY} ${OPENSSL_LIBRARIES} ${CMAKE_DL_LIBS})
set(FOLLY_LIBRARY_DIRS ${FOLLY_LIBRARY_DIR})
get_filename_component(absIncludeDir "../include" REALPATH BASE_DIR "${FOLLY_LIBRARY_DIR}")
set(FOLLY_INCLUDE_DIRS ${absIncludeDir})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Folly REQUIRED_VARS FOLLY_LIBRARY FOLLY_DC_LIBRARY)
