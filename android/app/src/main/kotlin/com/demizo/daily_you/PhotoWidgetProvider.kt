// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

package com.demizo.daily_you

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File

/**
 * Home screen widget showing one photo from the diary with its entry's
 * date; a tap opens that entry. The app picks the photo and writes a small
 * copy to its own folder, so this only loads that file.
 */
class PhotoWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val path = widgetData.getString("photo_widget_path", "").orEmpty()
    val photo =
        if (path.isEmpty() || !File(path).exists()) null
        else BitmapFactory.decodeFile(path)
    val entry = widgetData.getString("photo_widget_entry", "").orEmpty()
    val caption = widgetData.getString("photo_widget_caption", "").orEmpty()
    val empty =
        widgetData.getString(
            "photo_widget_empty", context.getString(R.string.photo_widget_empty_default))

    val tap =
        HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse(
                if (photo != null && entry.isNotEmpty()) "aiddiary://entry?id=$entry"
                else "aiddiary://open"))

    for (id in appWidgetIds) {
      val views =
          RemoteViews(context.packageName, R.layout.photo_widget).apply {
            if (photo != null) {
              setImageViewBitmap(R.id.photo_widget_image, photo)
              setViewVisibility(R.id.photo_widget_image, View.VISIBLE)
              setViewVisibility(R.id.photo_widget_scrim, View.VISIBLE)
              setTextViewText(R.id.photo_widget_caption, caption)
              setViewVisibility(R.id.photo_widget_caption, View.VISIBLE)
              setViewVisibility(R.id.photo_widget_empty, View.GONE)
            } else {
              setViewVisibility(R.id.photo_widget_image, View.GONE)
              setViewVisibility(R.id.photo_widget_scrim, View.GONE)
              setViewVisibility(R.id.photo_widget_caption, View.GONE)
              setTextViewText(R.id.photo_widget_empty, empty)
              setViewVisibility(R.id.photo_widget_empty, View.VISIBLE)
            }
            setOnClickPendingIntent(R.id.photo_widget_root, tap)
          }
      appWidgetManager.updateAppWidget(id, views)
    }
  }
}
