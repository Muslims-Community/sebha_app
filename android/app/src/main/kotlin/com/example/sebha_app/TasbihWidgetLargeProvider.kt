package com.example.sebha_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews

class TasbihWidgetLargeProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val sharedPref = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            val currentCount = sharedPref.getInt("current_count", 0)
            val dhikrName = sharedPref.getString("dhikr_name", "سبحان الله")
            val targetCount = sharedPref.getInt("target_count", 33)
            val targetReached = sharedPref.getBoolean("target_reached", false)

            val views = RemoteViews(context.packageName, R.layout.tasbih_widget_large)

            // Update widget content
            views.setTextViewText(R.id.current_count, currentCount.toString())
            views.setTextViewText(R.id.dhikr_name, dhikrName)
            views.setTextViewText(R.id.target_count, targetCount.toString())

            // Update progress bar
            val progress = if (targetCount > 0) ((currentCount.toFloat() / targetCount) * 100).toInt() else 0
            views.setProgressBar(R.id.progress_bar, 100, progress, false)

            // Show/hide target reached indicator
            if (targetReached) {
                views.setViewVisibility(R.id.target_reached, android.view.View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.target_reached, android.view.View.GONE)
            }

            // Set up increment button click
            val incrementIntent = Intent(context, TasbihWidgetLargeProvider::class.java)
            incrementIntent.action = "INCREMENT_ACTION"
            incrementIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            val incrementPendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId,
                incrementIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.increment_button, incrementPendingIntent)

            // Set up reset button click
            val resetIntent = Intent(context, TasbihWidgetLargeProvider::class.java)
            resetIntent.action = "RESET_ACTION"
            resetIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            val resetPendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId + 1000, // Different request code
                resetIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.reset_button, resetPendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        when (intent.action) {
            "INCREMENT_ACTION" -> {
                val sharedPref = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                val currentCount = sharedPref.getInt("current_count", 0)
                val newCount = currentCount + 1

                with(sharedPref.edit()) {
                    putInt("current_count", newCount)
                    apply()
                }

                // Update all widgets
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val thisWidget = ComponentName(context, TasbihWidgetLargeProvider::class.java)
                val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
                for (widgetId in allWidgetIds) {
                    updateAppWidget(context, appWidgetManager, widgetId)
                }
            }
            "RESET_ACTION" -> {
                val sharedPref = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

                with(sharedPref.edit()) {
                    putInt("current_count", 0)
                    putBoolean("target_reached", false)
                    apply()
                }

                // Update all widgets
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val thisWidget = ComponentName(context, TasbihWidgetLargeProvider::class.java)
                val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
                for (widgetId in allWidgetIds) {
                    updateAppWidget(context, appWidgetManager, widgetId)
                }
            }
        }
    }
}