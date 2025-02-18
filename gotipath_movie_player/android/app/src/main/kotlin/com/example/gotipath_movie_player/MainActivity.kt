package com.example.your_app_name

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "video_player_channel"
    private lateinit var videoPlayer: VideoPlayer

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        videoPlayer = VideoPlayer(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "togglePlayPause" -> {
                    val url = call.argument<String>("url")
                    val isPlaying = call.argument<Boolean>("isPlaying")
                    
                    if (url != null && isPlaying != null) {
                        val newState = videoPlayer.togglePlayPause(url, isPlaying)
                        result.success(newState)
                    } else {
                        result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        videoPlayer.release()
    }
} 