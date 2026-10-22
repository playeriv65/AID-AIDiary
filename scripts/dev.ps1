param(
  [ValidateSet('windows','windows-background','windows-driver','android','apk','release','test','test-unit','test-widget','test-integration','test-server','cli','test-cli','frame-rate','analyze','pub','screenshots')][string]$Target='windows',
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
# Flutter leaves a temp folder per test or build run that is interrupted;
# keep them off the small system drive.
$env:TEMP = $env:TMP = 'D:\software\temp'
New-Item -ItemType Directory -Force $env:TEMP | Out-Null
Set-Location (Split-Path $PSScriptRoot -Parent)
# A Gradle daemon holds gigabytes after a build; Android targets stop it as
# they finish rather than leave it idling.
# Flutter writes the wrapper on the first Android build; before that no
# daemon has started.
function Stop-Gradle {
  if (Test-Path .\android\gradlew.bat) {
    & .\android\gradlew.bat -p android --stop --quiet | Out-Null
  }
}
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
  'android' { flutter run -d $Device --flavor dev --print-dtd; Stop-Gradle }
  'apk' { flutter build apk --debug --flavor dev; $code = $LASTEXITCODE; Stop-Gradle; exit $code }
  # Frame rate with a 4000-entry diary, in profile mode
  # (integration_test/frame_rate_test.dart): -Device windows runs it in the
  # hidden background window, an adb serial on that phone or tablet. The
  # numbers and the journal scroll's timeline land in build\frame_rate.json
  # and build\frame_rate_timeline.json, pass or fail.
  'frame-rate' {
    $test = 'integration_test/frame_rate_test.dart'
    $driver = 'test_driver/integration_test.dart'
    if ($Device -eq 'windows') {
      $env:AID_BACKGROUND_WINDOW = '1'
      flutter drive --profile -d windows --endless-trace-buffer --driver=$driver --target=$test
      exit $LASTEXITCODE
    }
    # Phones and tablets here are arm64: build that alone (one AOT compile
    # instead of three; drive itself has no such option), then drive it.
    # The bar is the refresh rate the user set (e.g. 120 on a 144 Hz
    # panel); "null" leaves the test the display's fastest mode.
    $allowed = "$(adb -s $Device shell settings get system peak_refresh_rate)".Trim()
    $hz = if ($allowed -match '^\d+(\.\d+)?$') { [int][double]$allowed } else { 0 }
    flutter build apk --profile --flavor dev --target-platform android-arm64 -t $test "--dart-define=AID_TARGET_HZ=$hz"
    $code = $LASTEXITCODE
    Stop-Gradle
    if ($code -ne 0) { exit $code }
    # The app stays open afterwards, 4000 entries in, to try by hand.
    flutter drive --profile --flavor dev -d $Device --endless-trace-buffer --keep-app-running `
      --use-application-binary build\app\outputs\flutter-apk\app-dev-profile.apk `
      --driver=$driver --target=$test
  }
  # The everyday app: signed with android/key.properties (kept out of git)
  # and installed over the existing one, data kept, on every connected
  # phone or tablet.
  'release' {
    flutter build apk --release --flavor independent --target-platform android-arm64
    $code = $LASTEXITCODE
    Stop-Gradle
    if ($code -ne 0) { exit $code }
    $apk = 'build\app\outputs\flutter-apk\app-independent-release.apk'
    $failed = @()
    foreach ($line in (adb devices | Select-Object -Skip 1)) {
      $serial, $state = $line -split '\s+'
      if ($state -ne 'device' -or $serial -like 'emulator-*') { continue }
      Write-Host "Installing on $serial"
      adb -s $serial install -r $apk
      if ($LASTEXITCODE -ne 0) { $failed += $serial }
    }
    # HyperOS asks on the device before each adb install; a missed prompt
    # fails with INSTALL_FAILED_USER_RESTRICTED.
    if ($failed) { Write-Error "Install failed on: $($failed -join ', ')"; exit 1 }
  }
  'pub' { flutter pub get }
  # Test layers (see dart_test.yaml). Four workers keep runs from pinning
  # every core. Unit tests while iterating; all layers before committing.
  'test-unit' { flutter test -j 4 --exclude-tags widget,integration }
  'test-widget' { flutter test -j 4 --tags widget }
  'test-integration' { flutter test -j 4 --tags integration }
  # The Go sync server under server/.
  'test-server' {
    Push-Location server
    try {
      go vet ./...
      if ($LASTEXITCODE -eq 0) { go test ./... }
    } finally { Pop-Location }
  }
  # The aid command line under cli/, as build\cli\aid.exe.
  'cli' {
    Push-Location cli
    try {
      dart pub get
      New-Item -ItemType Directory -Force ..\build\cli | Out-Null
      if ($LASTEXITCODE -eq 0) { dart compile exe bin/aid.dart -o ..\build\cli\aid.exe }
    } finally { Pop-Location }
  }
  'test-cli' {
    Push-Location cli
    try {
      dart pub get
      if ($LASTEXITCODE -eq 0) { dart analyze; dart test }
    } finally { Pop-Location }
  }
  'test' { flutter test -j 4 }
  'analyze' { flutter analyze }
  # Renders artifacts/ui-*.png in widget tests; no window opens.
  'screenshots' { flutter test tool/screenshots/ }
}
exit $LASTEXITCODE
