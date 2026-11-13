package com.example.mi_iptv.player

import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.datasource.DefaultHttpDataSource
import androidx.media3.exoplayer.DefaultLoadControl
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.source.DefaultMediaSourceFactory
import androidx.media3.exoplayer.trackselection.AdaptiveTrackSelection
import androidx.media3.exoplayer.trackselection.DefaultTrackSelector

/**
 * Owns a single [ExoPlayer] instance for the Flutter process (TV-050 / TV-051 / TV-053).
 *
 * Lifecycle is tied to the Flutter engine plugin — not to Flutter screens.
 * Supports HLS, DASH, progressive TS/MP4 with content-type sniffing for
 * extension-less IPTV URLs, custom headers / User-Agent, and cross-protocol
 * redirects. ABR / buffer profiles (live vs VOD, device ceilings) land via
 * [AbrBufferConfig] (TV-053 / NFR-QOE-04).
 */
internal class Media3PlayerEngine(
    context: Context,
    private val onStatus: (Map<String, Any?>) -> Unit,
) {
    private val appContext = context.applicationContext
    private val mainHandler = Handler(Looper.getMainLooper())
    private var player: ExoPlayer? = null
    private var positionTicker: Runnable? = null
    private var lastHeaders: Map<String, String> = emptyMap()
    private var lastUserAgent: String? = null
    private var lastAbr: AbrBufferConfig = AbrBufferConfig.vodDefault

    private val listener = object : Player.Listener {
        override fun onPlaybackStateChanged(playbackState: Int) {
            emitStatus()
        }

        override fun onIsPlayingChanged(isPlaying: Boolean) {
            emitStatus()
            if (isPlaying) startTicker() else stopTicker()
        }

        override fun onPlayerError(error: PlaybackException) {
            // Do not include stream credentials, headers, or license payloads.
            // TV-054: errorCodeName feeds Dart PlaybackErrorClassifier.
            emitStatus(
                phase = "error",
                message = error.errorCodeName,
            )
            stopTicker()
        }
    }

    fun play(
        uri: String,
        protocol: String?,
        headers: Map<String, String>,
        userAgent: String?,
        abr: AbrBufferConfig,
    ) {
        runOnMain {
            val exo = ensurePlayer(
                headers = headers,
                userAgent = userAgent,
                abr = abr,
            )
            val item = MediaItem.Builder()
                .setUri(uri)
                .apply {
                    mimeTypeFor(protocol)?.let { setMimeType(it) }
                }
                .build()
            exo.setMediaItem(item)
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
            releasePlayerInternal()
            emitStatus(phase = "idle")
        }
    }

    private fun ensurePlayer(
        headers: Map<String, String>,
        userAgent: String?,
        abr: AbrBufferConfig,
    ): ExoPlayer {
        val existing = player
        if (existing != null &&
            headers == lastHeaders &&
            userAgent == lastUserAgent &&
            abr == lastAbr
        ) {
            return existing
        }
        if (existing != null) {
            releasePlayerInternal()
        }
        lastHeaders = headers
        lastUserAgent = userAgent
        lastAbr = abr

        val httpFactory = DefaultHttpDataSource.Factory()
            .setAllowCrossProtocolRedirects(true)
            .apply {
                if (!userAgent.isNullOrBlank()) {
                    setUserAgent(userAgent)
                }
                if (headers.isNotEmpty()) {
                    setDefaultRequestProperties(headers)
                }
            }

        val mediaSourceFactory = DefaultMediaSourceFactory(appContext)
            .setDataSourceFactory(httpFactory)

        val loadControl = DefaultLoadControl.Builder()
            .setBufferDurationsMs(
                abr.minBufferMs,
                abr.maxBufferMs,
                abr.bufferForPlaybackMs,
                abr.bufferForPlaybackAfterRebufferMs,
            )
            .build()

        val adaptiveFactory = AdaptiveTrackSelection.Factory(
            abr.minDurationForQualityIncreaseMs,
            /* maxDurationForQualityDecreaseMs */ 25_000,
            /* minDurationToRetainAfterDiscardMs */ 25_000,
            abr.bandwidthFraction,
        )
        val trackSelector = DefaultTrackSelector(appContext, adaptiveFactory)
        trackSelector.parameters = trackSelector.buildUponParameters()
            .setMaxVideoBitrate(abr.maxVideoBitrateBps)
            .setMaxVideoSize(abr.maxWidth, abr.maxHeight)
            .setForceHighestSupportedBitrate(false)
            .build()

        return ExoPlayer.Builder(appContext)
            .setMediaSourceFactory(mediaSourceFactory)
            .setLoadControl(loadControl)
            .setTrackSelector(trackSelector)
            .build()
            .also {
                it.addListener(listener)
                player = it
            }
    }

    private fun releasePlayerInternal() {
        stopTicker()
        player?.removeListener(listener)
        player?.release()
        player = null
        lastHeaders = emptyMap()
        lastUserAgent = null
    }

    private fun mimeTypeFor(protocol: String?): String? {
        return when (protocol?.lowercase()) {
            "hls" -> MimeTypes.APPLICATION_M3U8
            "dash" -> MimeTypes.APPLICATION_MPD
            "progressive_ts", "ts" -> MimeTypes.VIDEO_MP2T
            "progressive_mp4", "mp4" -> MimeTypes.VIDEO_MP4
            else -> null // unknown / extension-less — Media3 sniffs Content-Type
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

/** Wire mirror of Dart [AbrBufferProfile] (TV-053). */
internal data class AbrBufferConfig(
    val minBufferMs: Int,
    val maxBufferMs: Int,
    val bufferForPlaybackMs: Int,
    val bufferForPlaybackAfterRebufferMs: Int,
    val maxVideoBitrateBps: Int,
    val maxWidth: Int,
    val maxHeight: Int,
    val bandwidthFraction: Float,
    val minDurationForQualityIncreaseMs: Int,
) {
    companion object {
        val vodDefault = AbrBufferConfig(
            minBufferMs = 5_000,
            maxBufferMs = 50_000,
            bufferForPlaybackMs = 2_500,
            bufferForPlaybackAfterRebufferMs = 5_000,
            maxVideoBitrateBps = 6_000_000,
            maxWidth = 1920,
            maxHeight = 1080,
            bandwidthFraction = 0.85f,
            minDurationForQualityIncreaseMs = 10_000,
        )

        fun fromMap(raw: Map<*, *>?): AbrBufferConfig {
            if (raw == null) return vodDefault
            fun intOf(key: String, fallback: Int): Int {
                val value = raw[key]
                return when (value) {
                    is Number -> value.toInt()
                    else -> fallback
                }
            }
            fun floatOf(key: String, fallback: Float): Float {
                val value = raw[key]
                return when (value) {
                    is Number -> value.toFloat()
                    else -> fallback
                }
            }
            return AbrBufferConfig(
                minBufferMs = intOf("minBufferMs", vodDefault.minBufferMs),
                maxBufferMs = intOf("maxBufferMs", vodDefault.maxBufferMs),
                bufferForPlaybackMs = intOf(
                    "bufferForPlaybackMs",
                    vodDefault.bufferForPlaybackMs,
                ),
                bufferForPlaybackAfterRebufferMs = intOf(
                    "bufferForPlaybackAfterRebufferMs",
                    vodDefault.bufferForPlaybackAfterRebufferMs,
                ),
                maxVideoBitrateBps = intOf(
                    "maxVideoBitrateBps",
                    vodDefault.maxVideoBitrateBps,
                ),
                maxWidth = intOf("maxWidth", vodDefault.maxWidth),
                maxHeight = intOf("maxHeight", vodDefault.maxHeight),
                bandwidthFraction = floatOf(
                    "bandwidthFraction",
                    vodDefault.bandwidthFraction,
                ),
                minDurationForQualityIncreaseMs = intOf(
                    "minDurationForQualityIncreaseMs",
                    vodDefault.minDurationForQualityIncreaseMs,
                ),
            )
        }
    }
}
