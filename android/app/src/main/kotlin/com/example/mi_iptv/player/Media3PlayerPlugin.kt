package com.example.mi_iptv.player

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Flutter ↔ Media3 bridge (TV-050 / TV-051).
 *
 * Registers channels on the Flutter engine so [Media3PlayerEngine] outlives
 * individual Flutter routes / screens.
 */
class Media3PlayerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    companion object {
        const val METHOD_CHANNEL = "com.example.mi_iptv/media3_player"
        const val EVENT_CHANNEL = "com.example.mi_iptv/media3_player_events"
    }

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null
    private var engine: Media3PlayerEngine? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        engine = Media3PlayerEngine(binding.applicationContext) { status ->
            eventSink?.success(status)
        }
        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL).also {
            it.setMethodCallHandler(this)
        }
        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL).also {
            it.setStreamHandler(this)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        eventChannel?.setStreamHandler(null)
        eventChannel = null
        eventSink = null
        engine?.release()
        engine = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val player = engine
        if (player == null) {
            result.error("no_engine", "Media3 engine not attached", null)
            return
        }
        when (call.method) {
            "play" -> {
                val uri = call.argument<String>("uri")
                if (uri.isNullOrBlank()) {
                    result.error("bad_args", "uri required", null)
                    return
                }
                val protocol = call.argument<String>("protocol")
                val userAgent = call.argument<String>("userAgent")
                @Suppress("UNCHECKED_CAST")
                val rawHeaders = call.argument<Map<*, *>>("headers")
                val headers = linkedMapOf<String, String>()
                rawHeaders?.forEach { (key, value) ->
                    if (key is String && value is String) {
                        headers[key] = value
                    }
                }
                @Suppress("UNCHECKED_CAST")
                val abrMap = call.argument<Map<*, *>>("abr")
                player.play(
                    uri = uri,
                    protocol = protocol,
                    headers = headers,
                    userAgent = userAgent,
                    abr = AbrBufferConfig.fromMap(abrMap),
                )
                result.success(null)
            }
            "pause" -> {
                player.pause()
                result.success(null)
            }
            "seek" -> {
                val positionMs = call.argument<Number>("positionMs")?.toLong()
                if (positionMs == null) {
                    result.error("bad_args", "positionMs required", null)
                    return
                }
                player.seek(positionMs)
                result.success(null)
            }
            "stop" -> {
                player.stop()
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
}
