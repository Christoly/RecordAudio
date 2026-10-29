package com.christoly.audio_recorder_app

import android.content.Intent
import android.os.Build
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, "com.christoly.audio_recorder_app/storage")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getFreeBytes" -> try {
                        result.success(StatFs(filesDir.absolutePath).availableBytes)
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", e.message, null)
                    }
                    else -> result.notImplemented()
                }
            }

        MethodChannel(messenger, "com.christoly.audio_recorder_app/service")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "show" -> try {
                        val intent = Intent(this, RecordingService::class.java).apply {
                            action = RecordingService.ACTION_SHOW
                            putExtra(RecordingService.EXTRA_CHANNEL, call.argument<String>("channelName"))
                            putExtra(RecordingService.EXTRA_TITLE, call.argument<String>("title"))
                            putExtra(RecordingService.EXTRA_TEXT, call.argument<String>("text"))
                        }
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent)
                        }
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("SERVICE_FAILED", e.message, null)
                    }
                    "hide" -> {
                        stopService(Intent(this, RecordingService::class.java))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}