// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package dev.aid.diary

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/**
 * Home screen widget: today's date, whether today has an entry, the latest
 * entry's first line and the streak. The app writes localized text into the
 * widget data; the date check runs here so the widget turns over when the
 * diary day starts without the app.
 */
class DiaryWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    // The diary day, which the app may start a few hours after midnight.
    val dayStartHour =
        widgetData.getString("widget_day_start_hour", null)?.toIntOrNull() ?: 0
    val now = Date(System.currentTimeMillis() - dayStartHour * HOUR_MILLIS)
    val today = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(now)
    val written = widgetData.getString("widget_written_date", null) == today
    val status =
        widgetData.getString(
            if (written) "widget_done" else "widget_pending",
            context.getString(
                if (written) R.string.widget_done_default else R.string.widget_pending_default))
    val snippet = widgetData.getString("widget_snippet", "").orEmpty()
    val streak = widgetData.getString("widget_streak", "").orEmpty()

    val open =
        HomeWidgetLaunchIntent.getActivity(
            context, MainActivity::class.java, Uri.parse("aiddiary://open"))
    val write =
        HomeWidgetLaunchIntent.getActivity(
            context, MainActivity::class.java, Uri.parse("aiddiary://write"))

    for (id in appWidgetIds) {
      val views =
          RemoteViews(context.packageName, R.layout.diary_widget).apply {
            setTextViewText(R.id.widget_date, DateFormat.getDateInstance(DateFormat.FULL).format(now))
            setTextViewText(R.id.widget_status, status)
            setTextViewText(R.id.widget_snippet, snippet)
            setViewVisibility(R.id.widget_snippet, if (snippet.isEmpty()) View.GONE else View.VISIBLE)
            setTextViewText(R.id.widget_streak, streak)
            setViewVisibility(R.id.widget_streak, if (streak.isEmpty()) View.GONE else View.VISIBLE)
            setTextViewText(
                R.id.widget_write,
                widgetData.getString("widget_write", context.getString(R.string.widget_write_default)))
            setOnClickPendingIntent(R.id.widget_root, open)
            setOnClickPendingIntent(R.id.widget_write, write)
          }
      appWidgetManager.updateAppWidget(id, views)
    }
  }

  private companion object {
    const val HOUR_MILLIS = 3_600_000L
  }
}
