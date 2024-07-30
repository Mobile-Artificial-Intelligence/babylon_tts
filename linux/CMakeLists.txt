# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "babylon_tts")
project(${PROJECT_NAME} LANGUAGES CXX)

if (BUILD_BABYLON_SOURCE)
  add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_BINARY_DIR}/shared")

  set(babylon_tts_bundled_libraries
    $<TARGET_FILE:babylon_tts>
    PARENT_SCOPE
  )
else()
  set(babylon_tts_bundled_libraries
    "${CMAKE_CURRENT_SOURCE_DIR}/lib/libbabylon.so"
    "${CMAKE_CURRENT_SOURCE_DIR}/lib/libonnxruntime.so"
    "${CMAKE_CURRENT_SOURCE_DIR}/lib/libonnxruntime.so.1"
    "${CMAKE_CURRENT_SOURCE_DIR}/lib/libonnxruntime.so.1.19.0"
    PARENT_SCOPE
  )
endif()
