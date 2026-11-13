package com.example.mi_iptv.player

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Audio focus, keep-screen-on, and HDMI audio plug events (TV-052 / SRS §3).
 *
 * Activity-scoped window flags prevent screensaver while video plays.
 * No secrets — session control only.
 */
class PlaybackSessionPlugin :
    FlutterPlugin,
    ActivityAware,
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler,
    AudioManager.OnAudioFocusChangeListener {

    companion object {
        const val METHOD_CHANNEL = "com.example.mi_iptv/playback_session"
        const val EVENT_CHANNEL = "com.example.mi_iptv/playback_session_events"
    }

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var appContext: Context? = null
    private var activity: Activity? = null
    private var audioManager: AudioManager? = null
    private var focusRequest: AudioFocusRequest? = null
    private var hdmiReceiver: BroadcastReceiver? = null
    private var listening = false

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        appContext = binding.applicationContext
        audioManager = binding.applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL).also {
            it.setMethodCallHandler(this)
        }
        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL).also {
            it.setStreamHandler(this)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        stopInternal()
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        eventSink = null
        audioManager = null
        appContext = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "start" -> {
                startInternal()
                result.success(null)
            }
            "stop" -> {
                stopInternal()
                result.success(null)
            }
            "requestAudioFocus" -> {
                result.success(requestFocus())
            }
            "abandonAudioFocus" -> {
                abandonFocus()
                result.success(null)
            }
            "setKeepScreenOn" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                setKeepScreenOn(enabled)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    override fun onAudioFocusChange(focusChange: Int) {
        when (focusChange) {
            AudioManager.AUDIOFOCUS_LOSS,
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT,
            AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK,
            -> emit("audioFocusLost")
            AudioManager.AUDIOFOCUS_GAIN -> emit("audioFocusGained")
        }
    }

    private fun startInternal() {
        if (listening) return
        listening = true
        registerHdmiReceiver()
    }

    private fun stopInternal() {
        if (!listening && hdmiReceiver == null && focusRequest == null) {
            setKeepScreenOn(false)
            return
        }
        listening = false
        unregisterHdmiReceiver()
        abandonFocus()
        setKeepScreenOn(false)
    }

    private fun requestFocus(): Boolean {
        val am = audioManager ?: return false
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val attrs = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MOVIE)
                .build()
            val request = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                .setAudioAttributes(attrs)
                .setOnAudioFocusChangeListener(this)
                .build()
            focusRequest = request
            am.requestAudioFocus(request) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
        } else {
            @Suppress("DEPRECATION")
            am.requestAudioFocus(
                this,
                AudioManager.STREAM_MUSIC,
                AudioManager.AUDIOFOCUS_GAIN,
            ) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED
        }
    }

    private fun abandonFocus() {
        val am = audioManager ?: return
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            focusRequest?.let { am.abandonAudioFocusRequest(it) }
            focusRequest = null
        } else {
            @Suppress("DEPRECATION")
            am.abandonAudioFocus(this)
        }
    }

    private fun setKeepScreenOn(enabled: Boolean) {
        val window = activity?.window ?: return
        activity?.runOnUiThread {
            if (enabled) {
                window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            } else {
                window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            }
        }
    }

    private fun registerHdmiReceiver() {
        if (hdmiReceiver != null) return
        val context = appContext ?: return
        val receiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action != AudioManager.ACTION_HDMI_AUDIO_PLUG) return
                val state = intent.getIntExtra(AudioManager.EXTRA_AUDIO_PLUG_STATE, -1)
                when (state) {
                    0 -> emit("hdmiDisconnected")
                    1 -> emit("hdmiConnected")
                }
            }
        }
        hdmiReceiver = receiver
        val filter = IntentFilter(AudioManager.ACTION_HDMI_AUDIO_PLUG)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            @Suppress("UnspecifiedRegisterReceiverFlag")
            context.registerReceiver(receiver, filter)
        }
    }

    private fun unregisterHdmiReceiver() {
        val receiver = hdmiReceiver ?: return
        try {
            appContext?.unregisterReceiver(receiver)
        } catch (_: IllegalArgumentException) {
            // Already unregistered.
        }
        hdmiReceiver = null
    }

    private fun emit(signal: String) {
        eventSink?.success(mapOf("signal" to signal))
    }
}
