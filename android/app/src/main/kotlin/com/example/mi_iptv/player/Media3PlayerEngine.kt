package com.example.mi_iptv.player

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.exoplayer.ExoPlayer

/**
 * Owns a single [ExoPlayer] instance for the Flutter process (TV-050).
 *
 * Lifecycle is tied to the Flutter engine plugin — not to Flutter screens.
 * DRM (ClearKey / Widevine L3) hooks land in later playback tasks.
 */
internal class Media3PlayerEngine(
    context: Context,
    private val onStatus: (Map<String, Any?>) -> Unit,
) {
    private val appContext = context.applicationContext
    private val mainHandler = Handler(Looper.getMainLooper())
    private var player: ExoPlayer? = null
    private var positionTicker: Runnable? = null

    private val listener = object : Player.Listener {
        override fun onPlaybackStateChanged(playbackState: Int) {
            emitStatus()
        }

        override fun onIsPlayingChanged(isPlaying: Boolean) {
            emitStatus()
            if (isPlaying) startTicker() else stopTicker()
        }

        override fun onPlayerError(error: PlaybackException) {
            // Do not include stream credentials or license payloads in messages.
            emitStatus(
                phase = "error",
                message = error.errorCodeName,
            )
            stopTicker()
        }
    }

    fun play(uri: String) {
        runOnMain {
            val exo = ensurePlayer()
            exo.setMediaItem(MediaItem.fromUri(uri))
            exo.prepare()
            exo.playWhenReady = true
            emitStatus(phase = "buffering")
        }
    }

    fun pause() {
        runOnMain {
            player?.pause()
            emitStatus()
        }
    }

    fun seek(positionMs: Long) {
        runOnMain {
            player?.seekTo(positionMs.coerceAtLeast(0L))
            emitStatus()
        }
    }

    fun stop() {
        runOnMain {
            player?.stop()
            player?.clearMediaItems()
            stopTicker()
            emitStatus(phase = "idle")
        }
    }

    fun release() {
        runOnMain {
            stopTicker()
            player?.removeListener(listener)
            player?.release()
            player = null
            emitStatus(phase = "idle")
        }
    }

    private fun ensurePlayer(): ExoPlayer {
        val existing = player
        if (existing != null) return existing
        return ExoPlayer.Builder(appContext).build().also {
            it.addListener(listener)
            player = it
        }
    }

    private fun startTicker() {
        if (positionTicker != null) return
        val ticker = object : Runnable {
            override fun run() {
                emitStatus()
                mainHandler.postDelayed(this, 500L)
            }
        }
        positionTicker = ticker
        mainHandler.post(ticker)
    }

    private fun stopTicker() {
        positionTicker?.let { mainHandler.removeCallbacks(it) }
        positionTicker = null
    }

    private fun emitStatus(phase: String? = null, message: String? = null) {
        val exo = player
        val resolvedPhase = phase ?: phaseOf(exo)
        val payload = hashMapOf<String, Any?>(
            "phase" to resolvedPhase,
            "positionMs" to (exo?.currentPosition ?: 0L),
            "durationMs" to durationOf(exo),
            "message" to message,
        )
        onStatus(payload)
    }

    private fun phaseOf(exo: ExoPlayer?): String {
        if (exo == null) return "idle"
        return when (exo.playbackState) {
            Player.STATE_IDLE -> "idle"
            Player.STATE_BUFFERING -> "buffering"
            Player.STATE_ENDED -> "ended"
            Player.STATE_READY -> if (exo.isPlaying) "playing" else "paused"
            else -> "idle"
        }
    }

    private fun durationOf(exo: ExoPlayer?): Long {
        val duration = exo?.duration ?: 0L
        return if (duration < 0L) 0L else duration
    }

    private fun runOnMain(block: () -> Unit) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            block()
        } else {
            mainHandler.post(block)
        }
    }
}
