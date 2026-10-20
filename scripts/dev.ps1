param(
  [ValidateSet('windows','windows-background','windows-driver','android','apk','test','test-unit','test-widget','test-integration','analyze','pub','screenshots')][string]$Target='windows',
  # Flutter device id for 'android', e.g. a wireless adb serial from `flutter devices`.
  [string]$Device='emulator-5554'
)
$env:PUB_CACHE='D:\software\pub-cache'
$env:FLUTTER_ROOT='D:\software\flutter'
$env:Path='D:\software\flutter\bin;D:\software\android-sdk\platform-tools;' + $env:Path
$env:JAVA_HOME='D:\software\JDK'
$env:ANDROID_HOME='D:\software\android-sdk'
$env:ANDROID_USER_HOME='D:\software\android-user'
$env:ANDROID_AVD_HOME='D:\software\android-avd'
$env:GRADLE_USER_HOME='D:\software\gradle-cache'
Set-Location (Split-Path $PSScriptRoot -Parent)
switch ($Target) {
  'windows' { flutter run -d windows }
  # For agents: window off screen and never focused; prints the DTD URI for
  # the Dart MCP server (hot reload, widget tree, driver screenshots).
  'windows-background' {
    $env:AID_BACKGROUND_WINDOW = '1'
    flutter run -d windows --print-dtd -t test_driver/app.dart
  }
  'windows-driver' { flutter run -d windows -t test_driver/app.dart }
  # Prints the DTD URI so the Dart MCP server can attach for hot reload.
  'android' { flutter run -d $Device --flavor dev --print-dtd }
  'apk' { flutter build apk --debug --flavor dev }
  'pub' { flutter pub get }
  # Test layers (see dart_test.yaml). Four workers keep runs from pinning
  # every core. Unit tests while iterating; all layers before committing.
  'test-unit' { flutter test -j 4 --exclude-tags widget,integration }
  'test-widget' { flutter test -j 4 --tags widget }
  'test-integration' { flutter test -j 4 --tags integration }
  'test' { flutter test -j 4 }
  'analyze' { flutter analyze }
  # Renders artifacts/ui-*.png in widget tests; no window opens.
  'screenshots' { flutter test tool/screenshots/ }
}
exit $LASTEXITCODE
