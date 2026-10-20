// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package dev.aid.diary

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import es.antonborri.home_widget.HomeWidgetLaunchIntent

/**
 * Puts the lasting "quick write" notification back after a restart or an
 * app update, which clear it, without waiting for the app to be opened.
 * The app stores the localized text while the notification is on and
 * removes it when turned off; a tap opens a new entry like the widget's
 * write button. The app replaces this copy with its own once it runs.
 */
class QuickWriteRestoreReceiver : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
        intent.action != Intent.ACTION_MY_PACKAGE_REPLACED) return
    val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
    val title = prefs.getString("${PREFIX}quickWriteTitle", null) ?: return
    val text = prefs.getString("${PREFIX}quickWriteText", null) ?: return
    val manager = context.getSystemService(NotificationManager::class.java)

    val builder =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          manager.createNotificationChannel(
              NotificationChannel(
                  CHANNEL,
                  prefs.getString("${PREFIX}channelName.$CHANNEL", CHANNEL),
                  NotificationManager.IMPORTANCE_LOW))
          Notification.Builder(context, CHANNEL)
        } else {
          @Suppress("DEPRECATION") Notification.Builder(context)
        }
    val notification =
        builder
            .setSmallIcon(R.drawable.ic_notification)
            .setContentTitle(title)
            .setContentText(text)
            .setOngoing(true)
            .setShowWhen(false)
            .setContentIntent(
                HomeWidgetLaunchIntent.getActivity(
                    context, MainActivity::class.java, Uri.parse("aiddiary://write")))
            .build()
    manager.notify(NOTIFICATION_ID, notification)
  }

  private companion object {
    // Where Flutter's shared_preferences keeps its values, and its key prefix.
    const val PREFS = "FlutterSharedPreferences"
    const val PREFIX = "flutter."
    // Must match quickWriteChannelId and quickWriteNotificationId in Dart.
    const val CHANNEL = "aid_diary_quick_write"
    const val NOTIFICATION_ID = 5
  }
}
