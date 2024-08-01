# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "babylon_tts")
project(${PROJECT_NAME} LANGUAGES CXX)

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(babylon_tts_bundled_libraries
  # Defined in ../src/CMakeLists.txt.
  # This can be changed to accommodate different builds.
  "${CMAKE_CURRENT_SOURCE_DIR}/libbabylon.so"
  "${CMAKE_CURRENT_SOURCE_DIR}/libonnxruntime.so"
  "${CMAKE_CURRENT_SOURCE_DIR}/libonnxruntime.so.1.18.1"
  PARENT_SCOPE
)