# Frame rate with a large diary, driven the way a person and an agent
# drive the app: `aid` seeds the diary and opens places, flings come from
# `adb input swipe` on a phone or tablet and from `aid ui.fling` on this
# computer, and `aid perf.start` / `perf.stop` count the frames the app
# drew and how long each took. On a phone or tablet SurfaceFlinger's
# timestats also count what reached the screen.
#
# -Device <adb serial> measures the installed app as it is (a profile
# build from `dev.ps1 profile`), so the same build stays usable by hand.
# -Device windows starts the profile build from `dev.ps1 frame-rate` in a
# hidden window with its own scratch data, leaving the diary here alone.
#
# A scenario passes when at most allowedMissedShare of its frames ran over
# the frame budget and at most allowedSkippedShare of the refreshes while
# something moved were skipped, against the refresh rate the user set (or
# the display's). Scenarios and limits are in frame_rate.json. The numbers
# land in build\frame_rate.json, pass or fail; each scenario's timeline in
# build\frame_rate_timeline\<scenario>.json and a slower pass with every
# widget build, layout and paint in build\frame_rate_timeline\widgets.json
# (open them in ui.perfetto.dev). The app starts afresh with an endless
# timeline buffer, which otherwise keeps only the last seconds. Run it
# through `dev.ps1 frame-rate`, which sets up the tools.
param([Parameter(Mandatory)][string]$Device)
$ErrorActionPreference = 'Stop'
$config = Get-Content (Join-Path $PSScriptRoot 'frame_rate.json') -Raw | ConvertFrom-Json
$aidExe = (Resolve-Path 'build\cli\aid.exe').Path
$onComputer = $Device -eq 'windows'

function Invoke-Device { adb -s $Device shell @args }

# Runs one aid command; its result, or a stop with the app's error.
function Invoke-Aid {
  $target = if ($onComputer) { @() } else { @('-d', $Device) }
  $reply = (& $aidExe @target @args | Out-String) | ConvertFrom-Json
  if (-not $reply.ok) {
    throw "aid $($args -join ' '): $($reply.error.code): $($reply.error.message)"
  }
  $reply.result
}

function Wait-Settle { Start-Sleep -Milliseconds $config.settleMs }

# Down the list [times] times, then back up as many.
function Invoke-Flings([int]$times) {
  $fling = $config.fling
  foreach ($way in @(@($fling.from, $fling.to), @($fling.to, $fling.from))) {
    for ($i = 0; $i -lt $times; $i++) {
      if ($onComputer) {
        Invoke-Aid ui.fling "x=$($fling.x)" "from=$($way[0])" "to=$($way[1])" `
          "duration_ms=$($fling.durationMs)" | Out-Null
      } else {
        Invoke-Device input swipe $script:x ([int]($script:height * $way[0])) `
          $script:x ([int]($script:height * $way[1])) $fling.durationMs
      }
      Wait-Settle
    }
  }
}

# What reached the screen from the app's busiest layer (Flutter draws into
# a SurfaceView): the gaps between frames, in buckets of milliseconds.
function Read-Screen([string[]]$dump) {
  $layers = @()
  $layer = $null
  for ($i = 0; $i -lt $dump.Count; $i++) {
    $line = $dump[$i]
    if ($line -match '^layerName = (.*)') {
      $layer = if ($Matches[1].Contains($package)) { @{ name = $Matches[1].Trim() } } else { $null }
      if ($layer) { $layers += $layer }
    } elseif ($layer -and $line -match '^totalFrames = (\d+)') {
      $layer.frames = [int]$Matches[1]
    } elseif ($layer -and $line -match '^displayRefreshRate = (\d+)') {
      $layer.displayHz = [int]$Matches[1]
    } elseif ($layer -and $line -match '^present2present histogram' -and -not $layer.gaps) {
      $layer.gaps = $dump[$i + 1]
    }
  }
  $busiest = $layers | Sort-Object { $_.frames } -Descending | Select-Object -First 1
  if (-not $busiest -or -not $busiest.gaps) { throw "No frames from $package; is it on screen?" }
  $budgetMs = 1000 / $targetHz
  $shown = 0; $skipped = 0; $late = [ordered]@{}
  foreach ($bucket in $busiest.gaps.Trim().Split(' ')) {
    $ms, $count = $bucket -replace 'ms', '' -split '='
    $ms = [int]$ms; $count = [int]$count
    # A long gap is the screen at rest, not a skipped refresh.
    if ($count -eq 0 -or $ms -gt $config.stillMs) { continue }
    $missed = [math]::Max(0, [math]::Round($ms / $budgetMs) - 1)
    $shown += $count
    $skipped += $count * $missed
    if ($missed -gt 0) { $late["${ms}ms"] = $count }
  }
  [ordered]@{
    frames           = $busiest.frames
    skippedRefreshes = $skipped
    skippedShare     = if ($shown) { [math]::Round($skipped / ($shown + $skipped), 4) } else { 0 }
    displayHz        = $busiest.displayHz
    lateGaps         = $late
  }
}

function Measure-Scenario([scriptblock]$run) {
  if (-not $onComputer) {
    Invoke-Device dumpsys SurfaceFlinger --timestats -enable -clear | Out-Null
  }
  try {
    Invoke-Aid perf.start | Out-Null
    & $run
    # On a computer the bar is the display's rate, which the app reads.
    $stop = @("still_ms=$($config.stillMs)") + @(if ($targetHz) { "hz=$targetHz" })
    $result = [ordered]@{ app = Invoke-Aid perf.stop @stop }
    if (-not $onComputer) {
      $result.screen = Read-Screen (Invoke-Device dumpsys SurfaceFlinger --timestats -dump)
    }
    $result
  } finally {
    if (-not $onComputer) {
      Invoke-Device dumpsys SurfaceFlinger --timestats -disable | Out-Null
    }
  }
}

$app = $null
$scratch = $null
try {
  if ($onComputer) {
    # A fresh diary in a scratch folder, past the first-start pages; the
    # window stays off screen and never takes the focus.
    $scratch = Join-Path $env:TEMP "aid_frame_rate_$PID"
    New-Item -ItemType Directory -Force $scratch | Out-Null
    '{"onboardingDone": true}' | Set-Content (Join-Path $scratch 'config.json')
    $env:AID_DATA_DIR = $scratch
    $env:AID_API_INFO = Join-Path $scratch 'agent_api.json'
    $env:AID_BACKGROUND_WINDOW = '1'
    $env:FLUTTER_ENGINE_SWITCHES = '1'
    $env:FLUTTER_ENGINE_SWITCH_1 = 'endless-trace-buffer'
    $app = Start-Process build\windows\x64\runner\Profile\aid_diary.exe -PassThru
    $deadline = (Get-Date).AddSeconds($config.startTimeoutSeconds)
    while (-not (Test-Path $env:AID_API_INFO)) {
      if ((Get-Date) -gt $deadline -or $app.HasExited) { throw 'The app did not start' }
      Start-Sleep -Milliseconds 500
    }
  } else {
    # The app in front, nothing over it.
    Invoke-Device cmd statusbar collapse
  }

  $status = Invoke-Aid app.status
  if ($status.mode -notin 'profile', 'release') {
    throw "The app is a $($status.mode) build, whose frame rate means nothing; on a phone or tablet install a profile build with: ./scripts/dev.ps1 profile -Device $Device"
  }
  $package = $status.package
  if ($status.entries -lt $config.entries) {
    Invoke-Aid entry.seed "count=$($config.entries - $status.entries)" `
      "photos=$([math]::Max(0, $config.photos - $status.media))" | Out-Null
    $status = Invoke-Aid app.status
  }
  if ($status.media -lt $config.photos) {
    # Seeding adds entries; it does not change the ones there.
    throw "The diary has $($status.entries) entries and $($status.media) photos, short of $($config.photos) photos. Empty it on a test device with: build\cli\aid.exe -d $Device entry.erase_all confirm=delete-all --yes"
  }

  $targetHz = $null
  if (-not $onComputer) {
    # Started afresh, as only a starting engine takes the buffer switch.
    $activity = (Invoke-Device cmd package resolve-activity --brief $package | Select-Object -Last 1).Trim()
    Invoke-Device am force-stop $package
    Invoke-Device am start -n $activity --ez endless-trace-buffer true | Out-Null
    Invoke-Aid app.status | Out-Null
    # The bar is the rate the user set (e.g. 120 on a 144 Hz panel), else
    # the display's fastest mode; not the current one, so a system that
    # holds the app at 60 Hz fails.
    $peak = "$(Invoke-Device settings get system peak_refresh_rate)".Trim()
    $targetHz = if ($peak -match '^\d+(\.\d+)?$') { [double]$peak } else {
      ((Invoke-Device dumpsys display) | Select-String 'fps=([\d.]+)' -AllMatches).Matches |
        ForEach-Object { [double]$_.Groups[1].Value } | Measure-Object -Maximum | ForEach-Object Maximum
    }
    # Flings run along a vertical line in the current orientation.
    $size = (Invoke-Device dumpsys window displays | Select-String 'cur=(\d+)x(\d+)' |
      Select-Object -First 1).Matches[0].Groups
    $x = [int]([int]$size[1].Value * $config.fling.x)
    $height = [int]$size[2].Value
  }
  Wait-Settle

  $timelines = 'build\frame_rate_timeline'
  Remove-Item -LiteralPath $timelines -Recurse -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force $timelines | Out-Null
  # What a slow frame did: every widget build, layout and paint, in a pass
  # of its own as recording them slows frames down.
  Invoke-Aid ui.navigate "to=$($config.widgetTrace.open)" | Out-Null
  Wait-Settle
  Invoke-Aid trace start widgets=true | Out-Null
  Invoke-Flings $config.widgetTrace.flings
  Invoke-Aid trace stop "path=$timelines\widgets.json" | Out-Null

  $results = [ordered]@{}
  foreach ($scenario in $config.scenarios) {
    if ($scenario.open) {
      Invoke-Aid ui.navigate "to=$($scenario.open)" | Out-Null
      Wait-Settle
    }
    Invoke-Aid trace start | Out-Null
    $results[$scenario.name] = Measure-Scenario {
      if ($scenario.flings) { Invoke-Flings $scenario.flings }
      foreach ($tab in $scenario.tabs) {
        Invoke-Aid ui.navigate "to=$tab" | Out-Null
        Wait-Settle
      }
      if ($scenario.entries) {
        foreach ($entry in (Invoke-Aid entry.list "limit=$($scenario.entries)").entries) {
          Invoke-Aid ui.navigate to=entry "id=$($entry.id)" | Out-Null
          Wait-Settle
          Invoke-Aid ui.back | Out-Null
          Wait-Settle
        }
      }
    }
    Invoke-Aid trace stop "path=$timelines\$($scenario.name).json" | Out-Null
  }
} finally {
  if ($app -and -not $app.HasExited) { Stop-Process -Id $app.Id }
  if ($scratch) {
    Start-Sleep -Milliseconds 500
    Remove-Item -LiteralPath $scratch -Recurse -Force -ErrorAction SilentlyContinue
  }
}

$results | ConvertTo-Json -Depth 6 | Set-Content build\frame_rate.json -Encoding utf8
$slow = @()
foreach ($name in $results.Keys) {
  $app = $results[$name].app
  $screen = $results[$name].screen
  $line = "{0,-15} {1,5} frames  build p99 {2,5} ms  raster p99 {3,5} ms  over budget {4:P2}  skipped {5:P2}" -f `
    $name, $app.frames, $app.buildP99Ms, $app.rasterP99Ms, $app.missedShare, $app.skippedShare
  if ($screen) { $line += "  on screen skipped {0:P2} at {1} Hz" -f $screen.skippedShare, $screen.displayHz }
  Write-Host "$line  (target $($app.targetHz) Hz)"
  if ($app.missedShare -gt $config.allowedMissedShare -or
      $app.skippedShare -gt $config.allowedSkippedShare -or
      ($screen -and $screen.skippedShare -gt $config.allowedSkippedShare)) {
    $slow += $name
  }
}
if ($slow) {
  throw "Over the limits in frame_rate.json: $($slow -join ', ') (build\frame_rate.json)"
}
