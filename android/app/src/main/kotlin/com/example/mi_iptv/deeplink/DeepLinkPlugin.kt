package com.example.mi_iptv.deeplink

import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

/** CMP-050: delivers https VIEW intents to Dart. */
class DeepLinkPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel? = null
    private var initialLink: String? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL).also {
            it.setMethodCallHandler(this)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
        capture(binding.activity.intent, isInitial = true)
        binding.addOnNewIntentListener { intent ->
            capture(intent, isInitial = false)
            true
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    override fun onMethodCall(call: io.flutter.plugin.common.MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getInitialLink" -> {
                val link = initialLink
                initialLink = null
                result.success(link)
            }
            else -> result.notImplemented()
        }
    }

    private fun capture(intent: Intent?, isInitial: Boolean) {
        val data = intent?.dataString ?: return
        if (isInitial) {
            initialLink = data
        } else {
            channel?.invokeMethod("onLink", data)
        }
    }

    companion object {
        const val CHANNEL = "com.example.mi_iptv/deep_links"
    }
}
