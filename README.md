# babylon_tts

A Flutter package for Babylon TTS

## !! IMPORTANT !!

For android this package requires specific versions of the Android NDK and CMake. 
Older versions of the NDK and CMake should work but you'll have to 
manually update this packages `android/build.gradle` as versions are hardcoded.
The versions used to build the package are:

- NDK: `26.0.10792818`
- CMake: `3.26.0`

You should also specify `26.0.10792818` as the NDK version in your 
apps `android/app/build.gradle` file else a warning will be thrown.