param(
  [ValidateSet('windows','windows-build','windows-background','windows-driver','android','apk','profile','release','test','test-unit','test-widget','test-integration','test-server','cli','test-cli','frame-rate','analyze','pub','screenshots')][string]$Target='windows',
  # Flutter device id for 'android', e.g. a wireless adb serial from `flutter devices`.
  [string]$Device='emulator-5554'
)
# Where this computer keeps the toolchain, from scripts/dev.env (kept out of
# git; copy scripts/dev.env.example and see docs/SETUP.md).
$devEnv = Join-Path $PSScriptRoot 'dev.env'
if (-not (Test-Path $devEnv)) {
  Write-Error "scripts/dev.env is missing: copy scripts/dev.env.example to it and set this computer's paths (docs/SETUP.md)."
  exit 1
}
$tools = @{}
foreach ($line in Get-Content $devEnv) {
  if ($line -match '^\s*([A-Z_]+)\s*=\s*(.*?)\s*$') { $tools[$Matches[1]] = $Matches[2] }
}
foreach ($required in 'FLUTTER_ROOT', 'PUB_CACHE', 'JAVA_HOME', 'ANDROID_HOME') {
  if (-not $tools[$required]) {
    Write-Error "scripts/dev.env does not set $required."
    exit 1
  }
}
foreach ($name in 'FLUTTER_ROOT', 'PUB_CACHE', 'JAVA_HOME', 'ANDROID_HOME',
    'ANDROID_USER_HOME', 'ANDROID_AVD_HOME', 'GRADLE_USER_HOME') {
  if ($tools[$name]) { Set-Item "env:$name" $tools[$name] }
}
$env:Path = (Join-Path $env:FLUTTER_ROOT 'bin') + ';' +
  (Join-Path $env:ANDROID_HOME 'platform-tools') + ';' + $env:Path
# Flutter leaves a temp folder per test or build run that is interrupted;
# DEV_TEMP keeps them off a small system drive.
if ($tools['DEV_TEMP']) {
  $env:TEMP = $env:TMP = $tools['DEV_TEMP']
  New-Item -ItemType Directory -Force $env:TEMP | Out-Null
}
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
# Android builds sign with the release key when android/key.properties is
# there, so they install over each other. It is kept out of git: a new
# worktree has none, and would build an app the devices refuse.
if ($Target -in 'android', 'apk', 'profile', 'release' -and
    -not (Test-Path android\key.properties)) {
  Write-Error 'android/key.properties is missing: copy it from the main checkout, or make your own key from android/key.properties.example (docs/SETUP.md).'
  exit 1
}
# Flutter stages platform assets in a shared directory in this checkout.
# Concurrent native builds can silently package another platform's bundle.
$buildLock = $null
if ($Target -in 'windows', 'windows-build', 'windows-background', 'windows-driver',
    'android', 'apk', 'profile', 'release', 'frame-rate') {
  $lockPath = Join-Path (Get-Location) '.dart_tool/dev-build.lock'
  New-Item -ItemType Directory -Force (Split-Path $lockPath -Parent) | Out-Null
  try {
    $buildLock = [System.IO.File]::Open($lockPath, [System.IO.FileMode]::OpenOrCreate,
      [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
  } catch [System.IO.IOException] {
    Write-Error "Cannot acquire the Flutter build lock. Stop the other run/build in this checkout, or use another worktree. $($_.Exception.Message)"
    exit 1
  }
}
try {
switch ($Target) {
  'windows' { flutter run -d windows }
  'windows-build' { flutter build windows --debug --dart-define=AID_DEV_BUILD=true }
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
  # The dev app in profile mode (compiled as release is, so frame rates
  # mean something), installed over the existing one with its data kept.
  # Phones and tablets here are arm64: one AOT compile instead of three.
  'profile' {
    flutter build apk --profile --flavor dev --target-platform android-arm64
    $code = $LASTEXITCODE
    Stop-Gradle
    if ($code -ne 0) { exit $code }
    adb -s $Device install -r build\app\outputs\flutter-apk\app-dev-profile.apk
  }
  # Frame rate with a 4000-entry diary (scripts/frame_rate.ps1): of the
  # installed app on that phone or tablet, or with -Device windows of a
  # profile build made here, run hidden on scratch data. The numbers and
  # timelines land in build\frame_rate*.json.
  'frame-rate' {
    # aid as the sources have it, so its trace and actions match the app.
    & $PSCommandPath cli
    if ($Device -eq 'windows') {
      # Development build: test data and AID_DATA_DIR.
      flutter build windows --profile --dart-define=AID_DEV_BUILD=true
      if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }
    # It stops with an error when a scenario is too slow.
    & (Join-Path $PSScriptRoot 'frame_rate.ps1') -Device $Device
    exit 0
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
  'pub' {
    flutter pub get
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    Push-Location cli
    try { dart pub get } finally { Pop-Location }
  }
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
  'analyze' {
    # The root analyzer also sees the CLI package on a new checkout.
    Push-Location cli
    try { dart pub get } finally { Pop-Location }
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    flutter analyze
  }
  # Renders artifacts/ui-*.png in widget tests; no window opens.
  'screenshots' { flutter test tool/screenshots/ }
}
} finally {
  if ($null -ne $buildLock) { $buildLock.Dispose() }
}
exit $LASTEXITCODE
