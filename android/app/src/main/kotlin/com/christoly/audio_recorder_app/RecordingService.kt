package com.christoly.audio_recorder_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder

class RecordingService : Service() {
    companion object {
        const val ACTION_SHOW = "show"
        const val EXTRA_CHANNEL = "channelName"
        const val EXTRA_TITLE = "title"
        const val EXTRA_TEXT = "text"
        private const val CHANNEL_ID = "recording"
        private const val NOTIFICATION_ID = 1001
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action != ACTION_SHOW) {
            stopSelf()
            return START_NOT_STICKY
        }
        val channelName = intent.getStringExtra(EXTRA_CHANNEL) ?: "Recording"
        val title = intent.getStringExtra(EXTRA_TITLE) ?: ""
        val text = intent.getStringExtra(EXTRA_TEXT) ?: ""

        val notification = buildNotification(channelName, title, text)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        return START_NOT_STICKY
    }

    private fun buildNotification(
        channelName: String,
        title: String,
        text: String
    ): Notification {
        val builder: Notification.Builder
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(
                NotificationChannel(
                    CHANNEL_ID,
                    channelName,
                    NotificationManager.IMPORTANCE_LOW
                )
            )
            builder = Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            builder = Notification.Builder(this)
        }

        val launch = packageManager.getLaunchIntentForPackage(packageName)
        val tapIntent = PendingIntent.getActivity(
            this, 0, launch, PendingIntent.FLAG_IMMUTABLE
        )

        return builder
            .setSmallIcon(android.R.drawable.ic_btn_speak_now)
            .setContentTitle(title)
            .setContentText(text)
            .setContentIntent(tapIntent)
            .setOngoing(true)
            .build()
    }
}