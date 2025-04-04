#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance,
                     _In_opt_ HINSTANCE prev,
                     _In_ wchar_t *command_line,
                     _In_ int show_command) {
  // Attach to console when present
  if (!::AttachConsole(ATTACH_PARENT_PROCESS)) {
    ::AllocConsole();
  }

  // Initialize COM
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  // Create Dart project pointing to flutter_assets
  flutter::DartProject project(L"data");

  // Command line arguments
  std::vector<std::wstring> command_line_arguments = {
    L"--disable-dart-asserts",
    L"--enable-software-rendering",
  };

  // Create view controller (UPDATED CONSTRUCTOR)
  flutter::FlutterViewController controller(
    GetConsoleWindow(),
    std::move(project),
    command_line_arguments,
    nullptr);  // Set platform channels handler if needed

  if (!controller.GetEngine() || !controller.GetView()) {
    return EXIT_FAILURE;
  }

  // Message loop
  MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}