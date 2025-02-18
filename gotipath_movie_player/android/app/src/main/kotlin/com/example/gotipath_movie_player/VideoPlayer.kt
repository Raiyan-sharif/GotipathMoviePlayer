package com.example.your_app_name

import android.content.Context
import android.net.Uri
import android.view.ViewGroup
import android.widget.FrameLayout
import com.google.android.exoplayer2.ExoPlayer
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.ui.PlayerView

class VideoPlayer(private val context: Context) {
    private var player: ExoPlayer? = null
    private var playerView: PlayerView? = null

    fun togglePlayPause(url: String, isPlaying: Boolean): Boolean {
        if (player == null) {
            setupPlayer(url)
        }

        if (isPlaying) {
            player?.pause()
            return false
        } else {
            player?.play()
            return true
        }
    }

    private fun setupPlayer(url: String) {
        player = ExoPlayer.Builder(context).build()
        playerView = PlayerView(context)
        
        val mediaItem = MediaItem.fromUri(Uri.parse(url))
        player?.setMediaItem(mediaItem)
        
        playerView?.player = player
        playerView?.layoutParams = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        
        (context as MainActivity).addContentView(
            playerView,
            playerView?.layoutParams
        )
        
        player?.prepare()
    }

    fun release() {
        player?.release()
        player = null
    }
} 