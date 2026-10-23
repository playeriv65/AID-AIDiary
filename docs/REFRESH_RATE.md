# Refresh rate and scrolling performance

This guide covers Xiaomi's refresh-rate classification and measured native
scrolling. Windows scrollbar profiling and its current limits are below.

## Xiaomi (HyperOS)

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

## Windows scrollbar profiling

The owner requested a focused Windows pass on 2026-10-22; the broader Android
and cross-network passes remain deferred. Use the profile build/staging and
`windows_scroll.ps1` commands in [Setup](SETUP.md#windows-performance-profiling).
The fixture is generated, with 4000 entries and 400 photos, and the runtime
remains at its fixed executable path. Pointer motion goes through Flutter's
gesture system; each scrollbar result must also show a large change in scroll
position. A stream of redraws without actual list traversal is not a result.
Mouse samples follow display cadence rather than using a chain of 8 ms timers
that can itself cap generated input on Windows. A hover waits for rendered
frames so an auto-hidden thumb is actually available before pressing it.

The engine timings describe the native profile window's build/raster work and
frame pacing. They are not an OS-level presentation trace, a physical mouse
latency measurement, or proof about every diary/device. Cold first-use frames
and sustained traversals must be reported separately. Keep the existing 1%
limits; never hide long stalls by classifying them as idle in a continuous drag.

The desktop journal previously built 3591 intermediate rows for a single jump
through a 4000-entry fixture. Known, font-scaled preview/group extents let the
sliver skip those rows. The host regression checks real traversal, a bounded
number of row builds and large-text layout. Mobile content-sized rows remain.
An intermediate native pass still reached only 58–61 engine fps on a 120 Hz
display: Flutter's general varied-extent sliver repeatedly summed preceding
heights. `KnownExtentSliver` caches prefix offsets and uses binary lookup rather
than redoing that linear scan for every visible child during each frame.
CPU sampling then identified paragraph layout and widget/semantics churn as
the larger remaining cost. The desktop scroll cache now excludes offscreen
rows during traversal; ordinary visible previews retain their contents.
`windows_scroll.ps1 -CpuProfile` adds sampled main-isolate stacks in a separate
diagnostic run. Keep those timings distinct from the normal measurement.

### Windows result, 2026-10-23

Native Windows profile build, Skia, active engine display 120 Hz, 1265.6 by
682.4 logical pixels; generated 4000 entries and 400 photos. The runtime was
on-screen, nearly transparent and unfocused. No ordinary diary was used.

| Scenario | Engine fps | Build p99 | Raster p99 | Frames over budget | Skipped refresh share |
|---|---:|---:|---:|---:|---:|
| First ordinary swipe | 121.93 | 1.83 ms | 10.15 ms | 1.72% | 0.86% |
| Short thumb scrub down | 123.83 | 2.27 ms | 1.99 ms | 0% | 0% |
| Short thumb scrub back | 120.94 | 2.26 ms | 1.91 ms | 0% | 0% |
| Fast history traversal down | 92.35 | 11.45 ms | 2.25 ms | 3.31% | 23.09% |
| Fast history traversal back | 81.17 | 12.48 ms | 2.24 ms | 8.14% | 33.28% |

The short scrub moved 21,290 logical pixels in each direction over 1.5 seconds;
the fast traversal moved 559,225 pixels over 5 seconds in each direction.
Each result checks that the list actually moved. Engine fps can exceed the
nominal display rate slightly; these are not presented-frame counts.
The first swipe still has two long raster frames. Short scrubs meet the 1%
limits, but the full set does **not**: rapid history traversal remains a TODO.
The runner preserves the report and returns failure when any scenario exceeds
the limits. Passing functional tests is not a substitute for this performance
gate. The final implementation retains the indexed extents and visible-only
desktop scroll cache; text caching/semantics experiments without a meaningful
native gain were removed.
This addresses the pattern documented in Flutter's
[variable-height jumpTo issue](https://github.com/flutter/flutter/issues/52207);
use Flutter's [profile-mode procedure](https://docs.flutter.dev/cookbook/testing/integration/profiling)
when evaluating it, rather than debug-frame timing.

### Windows mouse-wheel behavior

Flutter's default [`ScrollPosition.pointerScroll`](https://api.flutter.dev/flutter/widgets/ScrollPosition/pointerScroll.html)
applies wheel deltas without animation. A high engine frame rate during a drag
does not imply that discrete wheel notches are interpolated. Windows primary
lists now use a short decaying tail, configured by
`scrolling.wheelDurationMs` (180 ms). Notches arriving during a tail accumulate
at its target; reversing starts from the visible position. Touch/trackpad
gestures and scrollbar dragging retain their native behavior. Reduced motion
disables the tail, and taps can interrupt it without being swallowed.
The same ticker runs across a burst: restarting a driven animation for every
notch introduced a stationary frame per notch despite good engine timings.
The configured duration controls exponential decay; the tail finishes when
the remaining distance is within the platform's scroll tolerance.

Use the profile build and stable staging procedure, then
`./scripts/windows_scroll.ps1 -Label wheel -WheelOnly`. The `ui.wheel` action
sends real Flutter mouse-wheel signals rather than substituting a touch fling.
The generated fixture remains isolated. After a separate warm-up notch, the
case sends 24 notches of 60 logical pixels at 60 ms intervals and observes the
settling tail. It requires the full 1440-pixel displacement, more distinct
per-frame offsets than input notches, no stationary frames during active
movement, and movement after the last notch. Sampling observes post-frame
callbacks without requesting extra frames after motion has stopped.
Frame timings use the existing budget limits and fail the runner on an overrun.
These are synthetic pointer signals in a native profile app, not a physical
mouse or OS presented-frame measurement. Do not equate this case with the
previous fast full-history scrollbar traversal.

Wheel verification on 2026-10-23 used the same 4000-entry/400-photo native
Windows profile fixture, Skia and a 120 Hz engine display. No Flutter test or
build ran concurrently with the final measurement. The final case recorded
205 engine frames and 204 distinct offsets for 24 notches: 60 → 1500 logical
pixels, with the last 12.70 pixels completed during the settling tail. There
were zero stationary frames inside active movement and zero skipped refreshes.
Build p99 was 1.61 ms and raster p99 1.81 ms; one 10.04 ms raster frame exceeded
the 8.33 ms budget (0.49%), within the existing 1% limit. The engine's fps
estimate was 129.52; it is not a physical presented-frame rate or a claim that
the 120 Hz display presented 129 frames per second.

The final full offline Flutter run passed 970 cases, including wheel bursts,
reversal, nested-list handoff, reduced motion, route isolation/Back, touch and
scrollbar interruption. Analysis, CLI measurement-tool analysis and the native
profile build passed. An earlier host run was stopped at an asset-loading
fixture inside fake time; shared config now loads in asynchronous `setUp` and
the corrected final run passed. An earlier wheel measurement overlapped host
tests and is not the final performance evidence. Final local reports are kept
under ignored `build/verification/windows-wheel-20261023/`. Ordinary diary data
and the owner's installed application were not changed. The separate extreme
scrollbar-traversal TODO remains open.
