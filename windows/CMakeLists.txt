cmake_minimum_required(VERSION 3.14)
set(PROJECT_NAME "flutter_assessment3")
project(${PROJECT_NAME} LANGUAGES CXX)

# Flutter integration
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
include(${FLUTTER_MANAGED_DIR}/generated_config.cmake)
include(${FLUTTER_MANAGED_DIR}/ephemeral/flutter_windows_plugin.cmake)

# Application code
add_subdirectory("runner")