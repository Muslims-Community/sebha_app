package com.example.sebha_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews

class TasbihWidgetSmallProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
            val sharedPref = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            val currentCount = sharedPref.getInt("current_count", 0)

            val views = RemoteViews(context.packageName, R.layout.tasbih_widget_small)

            // Update widget content
            views.setTextViewText(R.id.current_count, currentCount.toString())

            // Set up increment button click
            val incrementIntent = Intent(context, TasbihWidgetSmallProvider::class.java)
            incrementIntent.action = "INCREMENT_ACTION"
            incrementIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                appWidgetId,
                incrementIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.increment_button, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        if (intent.action == "INCREMENT_ACTION") {
            // Handle increment action - simplified for now
            val sharedPref = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val currentCount = sharedPref.getInt("current_count", 0)
            val newCount = currentCount + 1

            with(sharedPref.edit()) {
                putInt("current_count", newCount)
                apply()
            }

            // Update all widgets
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val thisWidget = ComponentName(context, TasbihWidgetSmallProvider::class.java)
            val allWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
            for (widgetId in allWidgetIds) {
                updateAppWidget(context, appWidgetManager, widgetId)
            }
        }
    }
}