param([ValidateSet('windows','windows-driver','android','test','analyze','pub','screenshots')][string]$Target='windows')
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
  'windows-driver' { flutter run -d windows -t test_driver/app.dart }
  'android' { flutter run -d emulator-5554 --flavor dev }
  'pub' { flutter pub get }
  'test' { flutter test }
  'analyze' { flutter analyze }
  # Renders artifacts/ui-*.png in widget tests; no window opens.
  'screenshots' { flutter test tool/screenshots/ }
}
exit $LASTEXITCODE
