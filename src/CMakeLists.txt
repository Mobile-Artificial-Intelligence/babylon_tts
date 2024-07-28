# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(babylon_tts VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_INSTALL_LIBDIR lib CACHE PATH "library install dir" FORCE)
set(BABYLON_LIB_INSTALL_DIR lib CACHE PATH "Babylon library install directory" FORCE)

add_subdirectory(babylon.cpp)

target_compile_definitions(babylon PUBLIC DART_SHARED_LIB)

# For Android, link with the C++ standard library and other required libraries
if(ANDROID)
    target_link_libraries(
        babylon
        log
        android
        atomic
        c++_shared  # or c++_static if using static runtime
    )
endif()
