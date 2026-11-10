# Checks scripts/android_device.ps1 without a device: a fake adb answers as
# a device would and records every command. Run with
# pwsh scripts/test_android_device.ps1; it exits 1 on the first failure.
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'android_device.ps1')

# What the fake device answers: its shell's id, su's id (null: no su), and
# pm's result.
$script:device = @{}
$script:calls = [Collections.Generic.List[string]]::new()
function adb {
  $line = $args -join ' '
  $script:calls.Add($line)
  $global:LASTEXITCODE = 0
  switch -Regex ($line) {
    ' shell id$' { return $script:device.ShellId }
    ' shell su -c id$' {
      if ($null -eq $script:device.SuId) { $global:LASTEXITCODE = 127; return }
      if ($script:device.SuId -notmatch '^uid=') { $global:LASTEXITCODE = 1 }
      return $script:device.SuId
    }
    'pm install' {
      if ($script:device.PmResult -ne 'Success') { $global:LASTEXITCODE = 1 }
      return $script:device.PmResult
    }
    ' install -r ' { return 'Success' }
    'resolve-activity' { return 'priority=0 preferredOrder=0', 'com.playeriv65.diary.beta/com.playeriv65.diary.MainActivity' }
    'pidof' { return '4242' }
    'logcat' { return 'The Dart VM service is listening on http://127.0.0.1:41234/abc=/' }
  }
}

$failures = 0
function Check([string]$Name, [scriptblock]$Device, [object]$ExpectedResult, [string[]]$ExpectedCalls) {
  $script:device = & $Device
  $script:calls.Clear()
  $result = Install-AndroidApk 'tablet' $apk 6>$null
  $problems = @()
  if ($result -ne $ExpectedResult) { $problems += "returned $result, expected $ExpectedResult" }
  $actual = @($script:calls)
  if (($actual -join "`n") -ne ($ExpectedCalls -join "`n")) {
    $problems += "commands:`n  $($actual -join "`n  ")`nexpected:`n  $($ExpectedCalls -join "`n  ")"
  }
  if ($problems) {
    Write-Output "FAIL $Name`n$($problems -join "`n")"
    $script:failures++
  } else {
    Write-Output "ok   $Name"
  }
}

$apk = 'build/app/outputs/flutter-apk/app-dev-debug.apk'
$staged = '/data/local/tmp/aid-dev-app-dev-debug.apk'
$pm = "pm install -r -i com.android.shell $staged"

Check 'the adb shell is root: pm runs in it' {
  @{ ShellId = 'uid=0(root) gid=0(root) context=u:r:ksu:s0'; PmResult = 'Success' }
} $true @(
  '-s tablet shell id',
  "-s tablet push $apk $staged",
  "-s tablet shell $pm",
  "-s tablet shell rm -f $staged")

Check 'su gives root: pm runs under su' {
  @{ ShellId = 'uid=2000(shell) gid=2000(shell)'; SuId = 'uid=0(root) gid=0(root)'; PmResult = 'Success' }
} $true @(
  '-s tablet shell id',
  '-s tablet shell su -c id',
  "-s tablet push $apk $staged",
  "-s tablet shell su -c '$pm'",
  "-s tablet shell rm -f $staged")

Check 'no su: adb install' {
  @{ ShellId = 'uid=2000(shell) gid=2000(shell)' }
} $true @(
  '-s tablet shell id',
  '-s tablet shell su -c id',
  "-s tablet install -r $apk")

Check 'su denies the shell: adb install' {
  @{ ShellId = 'uid=2000(shell) gid=2000(shell)'; SuId = 'Permission denied' }
} $true @(
  '-s tablet shell id',
  '-s tablet shell su -c id',
  "-s tablet install -r $apk")

Check 'a failed root install still removes the staged copy' {
  @{ ShellId = 'uid=2000(shell) gid=2000(shell)'; SuId = 'uid=0(root) gid=0(root)'; PmResult = 'Failure [INSTALL_FAILED_VERSION_DOWNGRADE]' }
} $false @(
  '-s tablet shell id',
  '-s tablet shell su -c id',
  "-s tablet push $apk $staged",
  "-s tablet shell su -c '$pm'",
  "-s tablet shell rm -f $staged")

$script:calls.Clear()
$url = Start-AndroidDebugApp 'tablet' 'com.playeriv65.diary.beta' 6>$null
if ($url -eq 'http://127.0.0.1:41234/abc=/' -and
    $script:calls -contains '-s tablet shell am start -W -n com.playeriv65.diary.beta/com.playeriv65.diary.MainActivity' -and
    $script:calls -contains '-s tablet logcat -d -v raw --pid=4242 -s flutter') {
  Write-Output 'ok   the started app''s own VM service address is read'
} else {
  Write-Output "FAIL the started app's VM service address: $url`n  $($script:calls -join "`n  ")"
  $failures++
}

if ($failures) { exit 1 }
