# Refresh rate on Xiaomi (HyperOS)

The app asks for the display's highest mode (`FlutterDisplayMode` in
`main.dart`) and gets it, except where the system has filed the app under
games. Found on a Redmi K80 (HyperOS 3, Snapdragon) in October 2026 by
reading the system's own logs and the decompiled system apps.

## How an app ends up at 60 Hz

1. When an app is installed, Qualcomm's workload classifier
   (`com.qualcomm.qti.workloadclassifier`) scans the APK (native libraries,
   size, permissions, required features, activity and package name words)
   and scores it as an app or a game. Its answer is read back through
   `BoostFramework.perfGetFeedback(0x1601, package)`: 2 is a game.
2. Joyose (`com.xiaomi.joyose`) asks for that answer. For a game it appends
   the package name to the game list it sends to PowerKeeper
   (`intent.action.TOP_GAME_LIST`, `isAppend=true`).
3. PowerKeeper ("Battery and performance", `com.miui.powerkeeper`) stores
   the list in a setting of its own (`key_top_names`). Installed apps named
   in it are its default games (`mDefaultGameApp`); a game the cloud has
   not tuned for a higher rate is held at 60 Hz whenever it is in front
   (`setScreenEffect(package, 60, 254)`, a vote above the app's request).
   Settings → Display → Refresh rate → custom shows such an app as "Based
   on app settings" with no switch.

The list is kept by package name. Uninstalling does not clear it, an update
does not reclassify, and declaring `android:appCategory` does not help:
only the next cloud `common_config` from Xiaomi resets the list (on the K80
the last one dates from February 2025).

The dev flavor's first package, `dev.aid.diary.dev`, was filed as a game
at some earlier install and stayed at 60 Hz in every build afterwards; the
same code under `dev.aid.diary.beta` ran at 120 Hz. The released package
`dev.aid.diary` is not on the list.

## Checking a device

- Settings → Display → Refresh rate → custom: the app shows a switch, not
  "Based on app settings".
- `adb shell dumpsys activity service com.miui.powerkeeper | grep
  mDefaultGameApp` does not name the package.
- Frame pacing as presented: `adb shell dumpsys SurfaceFlinger --timestats
  -enable -clear`, scroll with `adb shell input swipe` (real input, so the
  system's touch boost applies), then `--timestats -dump`: the app's
  SurfaceView layer should show `present2present` at 8 ms, not 16 ms.
  Turn timestats off again with `--timestats -disable`.

Others hit the same: Obsidian on a Xiaomi 13 Pro
(<https://forum.obsidian.md/t/no-high-refresh-rate-on-android-xiaomi-13-pro/76871>)
and Flutter apps (<https://github.com/flutter/flutter/issues/160952>).

## Requested profile measurements

The owner deferred the next performance pass on 2026-10-22. The measured backlog
is in [TODO.md](../TODO.md); [TESTING.md](TESTING.md) defines when this check is
needed. The following procedure applies when a pass is requested.

Use `./scripts/dev.ps1 frame-rate -Device <adb serial>` or `-Device windows`.
Device checks measure the installed build, so first install the correctly
signed profile flavor with `./scripts/dev.ps1 profile -Device <serial>`.
Windows builds a profile app with the development API and runs it hidden on
scratch `AID_DATA_DIR` data. Scenarios and thresholds belong to
`scripts/frame_rate.json`; the runner is `scripts/frame_rate.ps1`.

The runner seeds 4000 entries with 400 photos, navigates through `aid`, flings
with adb or `aid ui.fling`, and collects `perf.start`/`perf.stop` frame data.
On Android it also measures presented frames through SurfaceFlinger. Review
build/raster times, frames over budget and skipped refreshes against the
display's actual refresh mode, not debug timing alone.

Results go to `build/frame_rate.json` and scenario timelines under
`build/frame_rate_timeline/`; `widgets.json` contains the widget build/layout/
paint trace. `aid trace start`/`stop` captures a timeline for Perfetto. For a
phone-sized check on the tablet, record the existing size/density/rotation,
apply `wm size 1080x2400` and `wm density 420`, use the intended rotation, then
restore every changed device setting. Check the classifier diagnosis above
before attributing a 60 Hz cap to application performance.
