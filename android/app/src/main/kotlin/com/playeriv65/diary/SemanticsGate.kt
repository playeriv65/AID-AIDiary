// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package com.playeriv65.diary

import android.accessibilityservice.AccessibilityServiceInfo
import android.app.Application
import android.content.ComponentName
import android.database.ContentObserver
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.view.accessibility.AccessibilityManager
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterJNI
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.Collections
import java.util.WeakHashMap

/** Keeps Flutter's semantics tree off while every enabled accessibility
 * service is one that never needs this app's content (docs/ARCHITECTURE.md,
 * "Semantics gate").
 *
 * Android tells an app only that some service is on, and Flutter then
 * compiles the whole semantics tree every frame. Ad skippers and
 * auto-clickers cost the same as a screen reader. Dart decides which
 * services are such tools (`SemanticsGate` in lib/services); this side
 * holds the semantics off only for the exact service set Dart judged and
 * opens them on the main thread as soon as that set changes, so turning
 * on TalkBack, Switch Access or anything unknown enables them at once.
 *
 * The hook is the engine's own entry point: every engine gets a
 * [GatedFlutterJNI] through [FlutterInjector], and every path that turns
 * semantics on (the AccessibilityBridge, FlutterView, FlutterRenderer)
 * ends in [FlutterJNI.setSemanticsEnabled]. */
internal object SemanticsGate {
  private const val TAG = "SemanticsGate"

  /** `dart:ui` AccessibilityFeatures' accessibleNavigation bit. */
  private const val ACCESSIBLE_NAVIGATION = 1

  /** Stands for an enabled service the system names no component for:
   * not on any list, so it counts as a reader. */
  private const val UNNAMED_SERVICE = "unnamed"

  private lateinit var app: Application
  private lateinit var manager: AccessibilityManager
  private val engines: MutableSet<GatedFlutterJNI> =
    Collections.synchronizedSet(Collections.newSetFromMap(WeakHashMap()))
  private var installed = false
  private var channel: MethodChannel? = null
  private var channelMessenger: BinaryMessenger? = null

  /** The service set Dart found to hold no reader, or null. */
  private var heldFor: List<String>? = null

  /** Puts [GatedFlutterJNI] under every engine. Runs before any engine or
   * FlutterLoader exists, in [Application.onCreate]. */
  fun install(application: Application) {
    app = application
    manager = application.getSystemService(AccessibilityManager::class.java)
    try {
      FlutterInjector.setInstance(
        FlutterInjector.Builder()
          .setFlutterJNIFactory(object : FlutterJNI.Factory() {
            override fun provideFlutterJNI(): FlutterJNI = GatedFlutterJNI()
          })
          .build(),
      )
    } catch (error: IllegalStateException) {
      // Something read the injector first; Flutter then keeps its own
      // behavior, semantics on with any service.
      Log.w(TAG, "Semantics gate not installed", error)
      return
    }
    installed = true
    val main = Handler(Looper.getMainLooper())
    app.contentResolver.registerContentObserver(
      Settings.Secure.getUriFor(Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES),
      false,
      object : ContentObserver(main) {
        override fun onChange(selfChange: Boolean) = changed()
      },
    )
    // Both call back on the main thread, as the JNI requires.
    manager.addAccessibilityStateChangeListener { changed() }
    manager.addTouchExplorationStateChangeListener { changed() }
    if (Build.VERSION.SDK_INT >= 33) {
      manager.addAccessibilityServicesStateChangeListener(app.mainExecutor) { changed() }
    }
  }

  /** Serves the main engine's channel: Dart asks for the enabled services
   * and holds semantics off for a set it judged; it hears of every change. */
  fun attach(messenger: BinaryMessenger) {
    val methods = MethodChannel(messenger, "$NAMESPACE/semantics")
    methods.setMethodCallHandler { call, result ->
      when (call.method) {
        "services" -> result.success(services())

        "hold" -> {
          val judged = call.arguments<List<String>>()
          // A set that changed while Dart judged it is judged again.
          val held = installed && judged == services()
          if (held) {
            heldFor = judged
            reapply()
          }
          result.success(held)
        }

        else -> result.notImplemented()
      }
    }
    channel = methods
    channelMessenger = messenger
  }

  fun detach(messenger: BinaryMessenger) {
    if (messenger !== channelMessenger) return
    channel?.setMethodCallHandler(null)
    channel = null
    channelMessenger = null
  }

  /** Whether semantics may be on: false only while the enabled services
   * are exactly the set Dart judged. */
  fun allowsSemantics(): Boolean {
    val held = heldFor ?: return true
    return held != services()
  }

  internal fun register(engine: GatedFlutterJNI) {
    engines.add(engine)
  }

  internal fun features(flags: Int): Int = if (allowsSemantics()) flags else flags and ACCESSIBLE_NAVIGATION.inv()

  private fun changed() {
    reapply()
    channel?.invokeMethod("changed", services())
  }

  private fun reapply() {
    val current = synchronized(engines) { engines.toList() }
    current.forEach { it.reapply() }
  }

  /** The enabled services as full component names, sorted: the services
   * the user enabled in settings and those the system reports enabled. */
  private fun services(): List<String> {
    val configured = Settings.Secure.getString(app.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
      .orEmpty().split(':').filter { it.isNotBlank() }
      .map { ComponentName.unflattenFromString(it)?.flattenToString() ?: it }
    val running = manager
      .getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
      .map { info ->
        info.resolveInfo?.serviceInfo
          ?.let { ComponentName(it.packageName, it.name).flattenToString() }
          ?: info.id ?: UNNAMED_SERVICE
      }
    return (configured + running).distinct().sorted()
  }
}

/** An engine's JNI that asks [SemanticsGate] before turning semantics on.
 * It remembers what Flutter asked for, so the gate can apply a change. */
internal class GatedFlutterJNI : FlutterJNI() {
  private var semanticsRequested = false
  private var featuresRequested: Int? = null
  private var semanticsApplied: Boolean? = null

  init {
    SemanticsGate.register(this)
  }

  override fun setSemanticsEnabled(enabled: Boolean) {
    semanticsRequested = enabled
    semanticsApplied = enabled && SemanticsGate.allowsSemantics()
    super.setSemanticsEnabled(semanticsApplied!!)
  }

  /** Flutter's AccessibilityBridge reports accessible navigation once any
   * service queries a node, ad skippers too; while the gate holds, that is
   * not a person navigating by accessibility. */
  override fun setAccessibilityFeatures(flags: Int) {
    featuresRequested = flags
    super.setAccessibilityFeatures(SemanticsGate.features(flags))
  }

  /** Applies a change of the gate to what Flutter asked for. */
  fun reapply() {
    val semantics = semanticsRequested && SemanticsGate.allowsSemantics()
    if (semanticsApplied != null && semantics != semanticsApplied) {
      semanticsApplied = semantics
      super.setSemanticsEnabled(semantics)
    }
    featuresRequested?.let { super.setAccessibilityFeatures(SemanticsGate.features(it)) }
  }
}
