#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  if (RunsInBackground()) {
    // The engine asks for 1 ms timers (timeBeginPeriod) and times each
    // frame with them. Windows 11 drops that request for a process whose
    // windows are all out of sight, so the off-screen window would get
    // 15.6 ms ticks and about 64 frames a second whatever the display
    // does. Keep the request, so frame-rate runs see what a visible
    // window gets.
    PROCESS_POWER_THROTTLING_STATE throttling{};
    throttling.Version = PROCESS_POWER_THROTTLING_CURRENT_VERSION;
    throttling.ControlMask = PROCESS_POWER_THROTTLING_IGNORE_TIMER_RESOLUTION;
    throttling.StateMask = 0;
    ::SetProcessInformation(::GetCurrentProcess(), ProcessPowerThrottling,
                            &throttling, sizeof(throttling));
  }

  flutter::DartProject project(L"data");
  // Impeller builds every pipeline when the engine starts, and ANGLE
  // compiles each shader again on every launch: about a second before the
  // first frame here, against 0.2 s with Skia
  // (https://github.com/flutter/flutter/issues/191860). Use Skia until a
  // stable release fixes that.
  project.set_impeller_switch(flutter::ImpellerSwitch::Disabled);

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"AID Diary", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
