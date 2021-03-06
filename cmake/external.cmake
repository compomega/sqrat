# Enable the ExternalProject CMake module.
INCLUDE(ExternalProject)

OPTION(GIT_DEPENDENCIES "Download dependencies from Git instead." OFF)

IF(WIN32)
    SET(CMAKE_RELWITHDEBINFO_OPTIONS -DCMAKE_RELWITHDEBINFO_POSTFIX=_reldeb)
ENDIF(WIN32)

IF(GIT_DEPENDENCIES)
    SET(SQUIRREL_URL
        GIT_REPOSITORY https://github.com/comphack/squirrel3.git
        GIT_TAG comp_hack
    )
ELSE()
    SET(SQUIRREL_URL
        URL https://github.com/comphack/squirrel3/archive/comp_hack-20161214.zip
        URL_HASH SHA1=f70e9ec5eb6781d95689f69e999ce6142f3e2594
    )
ENDIF()

ExternalProject_Add(
    squirrel3

    ${SQUIRREL_URL}

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/squirrel3
    CMAKE_ARGS ${CMAKE_RELWITHDEBINFO_OPTIONS} -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirreld${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlibd${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(squirrel3 INSTALL_DIR)

SET_TARGET_PROPERTIES(squirrel3 PROPERTIES FOLDER "Dependencies")

SET(SQUIRREL_INCLUDE_DIRS "${INSTALL_DIR}/include")

FILE(MAKE_DIRECTORY "${SQUIRREL_INCLUDE_DIRS}")

ADD_LIBRARY(squirrel STATIC IMPORTED)
ADD_DEPENDENCIES(squirrel squirrel3)

IF(WIN32)
    SET_TARGET_PROPERTIES(squirrel PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirreld${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(squirrel PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}squirrel${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

SET_TARGET_PROPERTIES(squirrel PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
    "${SQUIRREL_INCLUDE_DIRS};${SQRAT_INCLUDE_DIRS}")

ADD_LIBRARY(sqstdlib STATIC IMPORTED)
ADD_DEPENDENCIES(sqstdlib squirrel3)

IF(WIN32)
    SET_TARGET_PROPERTIES(sqstdlib PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlibd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(sqstdlib PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}sqstdlib${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

SET_TARGET_PROPERTIES(sqstdlib PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
    "${SQUIRREL_INCLUDE_DIRS};${SQRAT_INCLUDE_DIRS}")

IF(GIT_DEPENDENCIES)
    SET(GOOGLETEST_URL
        GIT_REPOSITORY https://github.com/comphack/googletest.git
        GIT_TAG comp_hack
    )
ELSE()
    SET(GOOGLETEST_URL
        URL https://github.com/comphack/googletest/archive/comp_hack-20161214.zip
        URL_HASH SHA1=e2493c39bb60c380e394ca6a391630376cfdaeac
    )
ENDIF()

ExternalProject_Add(
    googletest

    ${GOOGLETEST_URL}

    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/googletest
    CMAKE_ARGS ${CMAKE_RELWITHDEBINFO_OPTIONS} -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR> "-DCMAKE_CXX_FLAGS=-std=c++11 ${SPECIAL_COMPILER_FLAGS}" -DUSE_STATIC_RUNTIME=${USE_STATIC_RUNTIME} -DCMAKE_DEBUG_POSTFIX=d

    # Dump output to a log instead of the screen.
    LOG_DOWNLOAD ON
    LOG_CONFIGURE ON
    LOG_BUILD ON
    LOG_INSTALL ON

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtestd${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmockd${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_maind${CMAKE_STATIC_LIBRARY_SUFFIX}

    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}
    BUILD_BYPRODUCTS <INSTALL_DIR>/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}
)

ExternalProject_Get_Property(googletest INSTALL_DIR)

SET_TARGET_PROPERTIES(googletest PROPERTIES FOLDER "Dependencies")

SET(GTEST_INCLUDE_DIRS "${INSTALL_DIR}/include")

FILE(MAKE_DIRECTORY "${GTEST_INCLUDE_DIRS}")

ADD_LIBRARY(gtest STATIC IMPORTED)
ADD_DEPENDENCIES(gtest googletest)

IF(WIN32)
    SET_TARGET_PROPERTIES(gtest PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtestd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(gtest PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gtest${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

SET_TARGET_PROPERTIES(gtest PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")

ADD_LIBRARY(gmock STATIC IMPORTED)
ADD_DEPENDENCIES(gmock googletest)

IF(WIN32)
    SET_TARGET_PROPERTIES(gmock PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmockd${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(gmock PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

SET_TARGET_PROPERTIES(gmock PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")

ADD_LIBRARY(gmock_main STATIC IMPORTED)
ADD_DEPENDENCIES(gmock_main googletest)

IF(WIN32)
    SET_TARGET_PROPERTIES(gmock_main PROPERTIES
        IMPORTED_LOCATION_RELEASE "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_RELWITHDEBINFO "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main_reldeb${CMAKE_STATIC_LIBRARY_SUFFIX}"
        IMPORTED_LOCATION_DEBUG "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_maind${CMAKE_STATIC_LIBRARY_SUFFIX}")
ELSE()
    SET_TARGET_PROPERTIES(gmock_main PROPERTIES IMPORTED_LOCATION
        "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}gmock_main${CMAKE_STATIC_LIBRARY_SUFFIX}")
ENDIF()

SET_TARGET_PROPERTIES(gmock_main PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${GTEST_INCLUDE_DIRS}")

SET(GMOCK_DIR "${INSTALL_DIR}")
