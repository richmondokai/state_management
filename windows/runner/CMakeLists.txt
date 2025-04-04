cmake_minimum_required(VERSION 3.14)
set(APPLICATION_NAME "flutter_assessment3")

# Define the executable
add_executable(${APPLICATION_NAME} WIN32
  "main.cpp"
  "flutter_window.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)

# Apply Flutter plugins
apply_standard_settings(${APPLICATION_NAME})
target_link_libraries(${APPLICATION_NAME} PRIVATE flutter flutter_wrapper_app)
add_dependencies(${APPLICATION_NAME} flutter_assemble)

# Enable C++17
target_compile_features(${APPLICATION_NAME} PRIVATE cxx_std_17)