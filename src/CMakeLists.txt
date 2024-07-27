# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(babylon_tts_library VERSION 0.0.1 LANGUAGES C)

add_library(babylon_tts SHARED
  "babylon_tts.c"
)

set_target_properties(babylon_tts PROPERTIES
  PUBLIC_HEADER babylon_tts.h
  OUTPUT_NAME "babylon_tts"
)

target_compile_definitions(babylon_tts PUBLIC DART_SHARED_LIB)
