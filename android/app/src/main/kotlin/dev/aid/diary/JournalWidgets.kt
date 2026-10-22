package dev.aid.diary

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

abstract class JournalWidgetProvider(private val kind: String) : HomeWidgetProvider() {
  override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray, data: SharedPreferences) {
    val day = Calendar.getInstance().apply {
      add(Calendar.HOUR_OF_DAY, -(data.getString("widget_day_start_hour", "0")?.toIntOrNull() ?: 0))
    }
    val prompts = try { JSONArray(data.getString("widget_prompts", "[]")) } catch (_: Exception) { JSONArray() }
    val index = if (prompts.length() > 0) (day.get(Calendar.DAY_OF_YEAR) - 1) % prompts.length() else 0
    val date = SimpleDateFormat("yyyy-MM-dd", Locale.US)
    val today = date.format(day.time)
    day.add(Calendar.DAY_OF_MONTH, -1)
    val yesterday = date.format(day.time)
    val lastDay = data.getString("widget_written_date", "")
    val currentStreak = if (lastDay == today || lastDay == yesterday) data.getString("widget_streak", "") else null
    for (id in ids) {
      val views = RemoteViews(context.packageName, R.layout.journal_widget)
      val title = when (kind) {
        "streak" -> R.string.streak_widget_name
        "prompt" -> R.string.prompt_widget_name
        else -> R.string.mood_widget_name
      }
      views.setTextViewText(R.id.journal_widget_title, context.getString(title))
      views.setViewVisibility(R.id.journal_widget_moods, if (kind == "mood") View.VISIBLE else View.GONE)
      views.setViewVisibility(R.id.journal_widget_text, if (kind == "mood") View.GONE else View.VISIBLE)
      val text = if (kind == "prompt") prompts.optString(index, context.getString(R.string.widget_write_default))
          else currentStreak?.takeIf { it.isNotEmpty() } ?: data.getString("widget_streak_zero", context.getString(R.string.widget_write_default))
      views.setTextViewText(R.id.journal_widget_text, text)
      val uri = if (kind == "prompt") "aiddiary://prompt?index=$index" else "aiddiary://write"
      views.setOnClickPendingIntent(R.id.journal_widget_root, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse(uri)))
      val moodIds = intArrayOf(R.id.widget_mood_low, R.id.widget_mood_down, R.id.widget_mood_neutral, R.id.widget_mood_good, R.id.widget_mood_great)
      for ((i, view) in moodIds.withIndex()) {
        views.setOnClickPendingIntent(view, HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java, Uri.parse("aiddiary://mood?value=${i - 2}")))
      }
      manager.updateAppWidget(id, views)
    }
  }
}

class StreakWidgetProvider : JournalWidgetProvider("streak")
class PromptWidgetProvider : JournalWidgetProvider("prompt")
class MoodWidgetProvider : JournalWidgetProvider("mood")
