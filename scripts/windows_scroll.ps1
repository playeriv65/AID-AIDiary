# Windows-only profile measurements over generated data. Never attaches to the
# owner's installation. Build/stage first with dev.ps1 windows-profile-build
# and windows-profile-stage; run this script through the configured Dart SDK.
param([ValidatePattern('^[a-z0-9-]+$')][string]$Label = 'current', [switch]$CpuProfile)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$localTools = @{}
foreach ($line in Get-Content (Join-Path $PSScriptRoot 'dev.env')) {
  if ($line -match '^\s*([A-Z_]+)\s*=\s*(.*?)\s*$') { $localTools[$Matches[1]] = $Matches[2] }
}
$runtime = $localTools['DEV_WINDOWS_RUNTIME']
if (-not $runtime -or -not (Test-Path (Join-Path $runtime '.aid-runtime'))) {
  throw 'Stage the configured Windows development runtime first.'
}
$output = Join-Path $repo "build\windows-scroll\$Label"
$data = Join-Path $repo 'build\windows-scroll\data'
New-Item -ItemType Directory -Force $data,$output | Out-Null
$measureLock = $null
$info = Join-Path $data 'agent_api.json'
$saved = @{}
foreach ($name in 'AID_DATA_DIR','AID_API_INFO','AID_BACKGROUND_WINDOW','AID_PROFILE_CPU','FLUTTER_ENGINE_SWITCHES','FLUTTER_ENGINE_SWITCH_1') {
  $saved[$name] = [Environment]::GetEnvironmentVariable($name)
}
$watcher = [IO.FileSystemWatcher]::new($data, 'agent_api.json')
$app = $null
try {
  $measureLock = [IO.File]::Open((Join-Path $data '.measurement.lock'),
    [IO.FileMode]::OpenOrCreate, [IO.FileAccess]::ReadWrite, [IO.FileShare]::None)
  if (Test-Path $info) { throw 'A previous test API file exists; check its owner before continuing.' }
  if (-not (Test-Path (Join-Path $data 'config.json'))) {
    '{"onboardingDone":true,"deviceName":"Performance test"}' | Set-Content (Join-Path $data 'config.json')
  }
  $env:AID_DATA_DIR = $data
  $env:AID_API_INFO = $info
  $env:AID_BACKGROUND_WINDOW = '1'
  $env:AID_PROFILE_CPU = if ($CpuProfile) { '1' } else { '0' }
  $env:FLUTTER_ENGINE_SWITCHES = '1'
  $env:FLUTTER_ENGINE_SWITCH_1 = 'endless-trace-buffer'
  $app = Start-Process -FilePath (Join-Path $runtime 'aid_diary.exe') -WorkingDirectory $runtime -PassThru -WindowStyle Hidden -RedirectStandardOutput (Join-Path $output 'stdout.log') -RedirectStandardError (Join-Path $output 'stderr.log')
  if (-not (Test-Path $info)) {
    $change = $watcher.WaitForChanged([IO.WatcherChangeTypes]::Changed, 60000)
    if ($change.TimedOut) { throw "The isolated app did not become ready. Read $output\stderr.log." }
  }
  Start-Sleep -Milliseconds 500
  $endpoint = Get-Content -LiteralPath $info -Raw | ConvertFrom-Json
  if ($endpoint.pid -ne $app.Id) { throw 'The API does not belong to the launched test process.' }
  Push-Location (Join-Path $repo 'cli')
  try {
    & (Join-Path $localTools['FLUTTER_ROOT'] 'bin\dart.bat') run tool/measure_scroll.dart $output
    if ($LASTEXITCODE -ne 0) { throw "Measurement failed; see $output." }
    $report = Get-Content -LiteralPath (Join-Path $output 'summary.json') -Raw | ConvertFrom-Json
    $unmet = @($report.PSObject.Properties | Where-Object { $_.Value.withinLimits -eq $false } | ForEach-Object Name)
    if ($unmet.Count) { throw "Recorded results exceed the frame limits: $($unmet -join ', '). See $output\summary.json." }
  } finally { Pop-Location }
} finally {
  $watcher.Dispose()
  if ($app -and -not $app.HasExited) { Stop-Process -Id $app.Id }
  if ($app -and (Test-Path $info)) { Remove-Item -LiteralPath $info }
  foreach ($name in $saved.Keys) { [Environment]::SetEnvironmentVariable($name, $saved[$name]) }
  if ($measureLock) { $measureLock.Dispose() }
}
