#include "flutter_window.h"

#include <flutter/standard_method_codec.h>
#include <optional>

#include "flutter/generated_plugin_registrant.h"

FlutterWindow::FlutterWindow(const flutter::DartProject &project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  device_keys_ = RegisterDeviceKeys(flutter_controller_->engine()->messenger());
  nearby_settings_ =
      RegisterNearbySettings(flutter_controller_->engine()->messenger());
  window_chrome_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), "aid/window_chrome",
          &flutter::StandardMethodCodec::GetInstance());
  window_chrome_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue> &call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
                 result) {
        if (call.method_name() != "setTheme") {
          result->NotImplemented();
          return;
        }
        const auto *args = std::get_if<flutter::EncodableMap>(call.arguments());
        if (!args) {
          result->Error("invalid_arguments", "Expected a caption palette.");
          return;
        }
        const auto color = [args](const char *key) -> std::optional<COLORREF> {
          const auto it = args->find(flutter::EncodableValue(key));
          if (it == args->end())
            return std::nullopt;
          int64_t argb;
          if (const auto *value = std::get_if<int64_t>(&it->second)) {
            argb = *value;
          } else if (const auto *value32 = std::get_if<int32_t>(&it->second)) {
            argb = *value32;
          } else {
            return std::nullopt;
          }
          return RGB((argb >> 16) & 255, (argb >> 8) & 255, argb & 255);
        };
        const auto background = color("background");
        const auto foreground = color("foreground");
        const auto dark = args->find(flutter::EncodableValue("dark"));
        if (!background || !foreground || dark == args->end() ||
            !std::holds_alternative<bool>(dark->second)) {
          result->Error("invalid_arguments",
                        "Invalid caption colors or brightness.");
          return;
        }
        const HRESULT status = SetCaptionTheme(*background, *foreground,
                                               std::get<bool>(dark->second));
        if (FAILED(status) && status != E_INVALIDARG) {
          result->Error("caption_theme_failed",
                        "Windows rejected the caption palette.");
          return;
        }
        result->Success();
      });
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() { this->Show(); });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  window_chrome_ = nullptr;
  nearby_settings_ = nullptr;
  device_keys_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
  case WM_FONTCHANGE:
    flutter_controller_->engine()->ReloadSystemFonts();
    break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
