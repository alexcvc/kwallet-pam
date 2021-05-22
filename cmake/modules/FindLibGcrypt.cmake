
# - Try to find the Gcrypt library
# Once run this will define
#
#  LIBGCRYPT_FOUND - set if the system has the gcrypt library
#  LIBGCRYPT_INCLUDE_DIR - the path to find the gcrypt header
#  LIBGCRYPT_CFLAGS - the required gcrypt compilation flags
#  LIBGCRYPT_LIBRARIES - the linker libraries needed to use the gcrypt library
#
# libgcrypt is moving to pkg-config, but earlier version don't have it
#
# SPDX-FileCopyrightText: 2006 Brad Hards <bradh@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

if(NOT LibGcrypt_FIND_VERSION)
    set(LibGcrypt_FIND_VERSION "1.6.1")
endif()

#search in typical paths for libgcrypt-config
FIND_PROGRAM(LIBGCRYPTCONFIG_EXECUTABLE NAMES libgcrypt-config)

#reset variables
set(LIBGCRYPT_LIBRARIES)
set(LIBGCRYPT_INCLUDE_DIR)
set(LIBGCRYPT_CFLAGS)

# if libgcrypt-config has been found
IF(LIBGCRYPTCONFIG_EXECUTABLE)

  # workaround for MinGW/MSYS
  # CMake can't starts shell scripts on windows so it need to use sh.exe
  EXECUTE_PROCESS(COMMAND sh ${LIBGCRYPTCONFIG_EXECUTABLE} --libs RESULT_VARIABLE _return_VALUE OUTPUT_VARIABLE LIBGCRYPT_LIBRARIES OUTPUT_STRIP_TRAILING_WHITESPACE)
  EXECUTE_PROCESS(COMMAND sh ${LIBGCRYPTCONFIG_EXECUTABLE} --prefix RESULT_VARIABLE _return_VALUE OUTPUT_VARIABLE LIBGCRYPT_PREFIX OUTPUT_STRIP_TRAILING_WHITESPACE)
  EXECUTE_PROCESS(COMMAND sh ${LIBGCRYPTCONFIG_EXECUTABLE} --cflags RESULT_VARIABLE _return_VALUE OUTPUT_VARIABLE LIBGCRYPT_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
  EXECUTE_PROCESS(COMMAND sh ${LIBGCRYPTCONFIG_EXECUTABLE} --version RESULT_VARIABLE _return_VALUEVersion OUTPUT_VARIABLE LIBGCRYPT_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)

  IF(NOT LIBGCRYPT_CFLAGS AND NOT _return_VALUE)
    SET(LIBGCRYPT_CFLAGS " ")
  ENDIF(NOT LIBGCRYPT_CFLAGS AND NOT _return_VALUE)

  IF(LIBGCRYPT_PREFIX)
    SET(LIBGCRYPT_INCLUDE_DIR "${LIBGCRYPT_PREFIX}/include")
  ENDIF(LIBGCRYPT_PREFIX)

  IF(LIBGCRYPT_LIBRARIES AND LIBGCRYPT_CFLAGS)
    SET(LIBGCRYPT_FOUND TRUE)
  ENDIF(LIBGCRYPT_LIBRARIES AND LIBGCRYPT_CFLAGS)

  if(LIBGCRYPT_VERSION VERSION_LESS ${LibGcrypt_FIND_VERSION})
     message(WARNING "libgcrypt found but version is less than required, Found ${LIBGCRYPT_VERSION} Required ${LibGcrypt_FIND_VERSION}")
     SET(LIBGCRYPT_FOUND FALSE)
  endif()

ENDIF(LIBGCRYPTCONFIG_EXECUTABLE)

if (LIBGCRYPT_FOUND)
   if (NOT LibGcrypt_FIND_QUIETLY)
      message(STATUS "Found libgcrypt: ${LIBGCRYPT_LIBRARIES}")
   endif (NOT LibGcrypt_FIND_QUIETLY)
else (LIBGCRYPT_FOUND)
   if (LibGcrypt_FIND_REQUIRED)
      message(WARNING "Could not find libgcrypt libraries")
   endif (LibGcrypt_FIND_REQUIRED)
endif (LIBGCRYPT_FOUND)

MARK_AS_ADVANCED(LIBGCRYPT_CFLAGS LIBGCRYPT_LIBRARIES)
