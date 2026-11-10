# Installs and starts the app on an Android device for scripts/dev.ps1
# (docs/SETUP.md, "Test devices"). HyperOS asks on the device before each
# adb install; as root, pm installs without asking. Checked without a device
# by scripts/test_android_device.ps1.

# Where the APK waits for pm: a folder the shell user writes and the system
# installer reads.
$script:AndroidStaging = '/data/local/tmp'
# The installer of record, as for adb install.
$script:AndroidInstaller = 'com.android.shell'

# How the device's adb shell reaches root: 'shell' when it already runs as
# root, 'su' when su gives it root, else none.
function Get-AdbRoot([string]$Serial) {
  if ("$(adb -s $Serial shell id)" -match '^uid=0\(') { return 'shell' }
  if ("$(adb -s $Serial shell su -c id 2>$null)" -match '^uid=0\(') { return 'su' }
  return $null
}

# Installs $Apk over the existing app, keeping its data. With root: push it to
# the staging folder, pm install as root, remove the copy. Otherwise adb
# install. Returns whether it installed.
function Install-AndroidApk([string]$Serial, [string]$Apk) {
  $root = Get-AdbRoot $Serial
  if (-not $root) {
    Write-Host "Installing on $Serial with adb install (no root; the device may ask)"
    adb -s $Serial install -r $Apk | Out-Host
    return $LASTEXITCODE -eq 0
  }
  Write-Host "Installing on $Serial as root"
  $staged = "$script:AndroidStaging/aid-dev-$([IO.Path]::GetFileName($Apk))"
  adb -s $Serial push $Apk $staged | Out-Host
  if ($LASTEXITCODE -ne 0) { return $false }
  $install = "pm install -r -i $script:AndroidInstaller $staged"
  $output = if ($root -eq 'su') {
    adb -s $Serial shell "su -c '$install'"
  } else {
    adb -s $Serial shell $install
  }
  $code = $LASTEXITCODE
  $output | Out-Host
  adb -s $Serial shell rm -f $staged | Out-Host
  # Some adb versions exit 0 after a failed install; pm says Success.
  return $code -eq 0 -and "$output" -match '\bSuccess\b'
}

# Starts $Package's launcher activity and returns its Dart VM service URL,
# read from that process's own log lines, for flutter attach.
function Start-AndroidDebugApp([string]$Serial, [string]$Package, [int]$TimeoutSeconds = 30) {
  $activity = adb -s $Serial shell cmd package resolve-activity --brief -c android.intent.category.LAUNCHER $Package |
    Select-Object -Last 1
  if ("$activity" -notmatch '/') { throw "$Package has no launcher activity on $Serial." }
  adb -s $Serial shell am start -W -n $activity | Out-Host
  if ($LASTEXITCODE -ne 0) { throw "Could not start $activity on $Serial." }
  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  do {
    $processId = "$(adb -s $Serial shell pidof $Package)".Trim()
    if ($processId) {
      $log = adb -s $Serial logcat -d -v raw --pid=$processId -s flutter
      if ("$log" -match 'listening on (http://\S+)') { return $Matches[1] }
    }
    Start-Sleep -Milliseconds 500
  } while ((Get-Date) -lt $deadline)
  throw "$Package on $Serial printed no Dart VM service address within $TimeoutSeconds s."
}
