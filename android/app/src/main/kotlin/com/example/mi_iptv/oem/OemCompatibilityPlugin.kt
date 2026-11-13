package com.example.mi_iptv.oem

import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Exposes Build.MANUFACTURER / MODEL / SDK_INT to Dart (TV-011 / NFR-009).
 *
 * No device secrets — fingerprint only for OEM profile selection.
 */
class OemCompatibilityPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    companion object {
        const val METHOD_CHANNEL = "com.example.mi_iptv/oem_compatibility"
    }

    private var methodChannel: MethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, METHOD_CHANNEL).also {
            it.setMethodCallHandler(this)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getDeviceIdentity" -> {
                result.success(
                    mapOf(
                        "manufacturer" to Build.MANUFACTURER,
                        "model" to Build.MODEL,
                        "apiLevel" to Build.VERSION.SDK_INT,
                    ),
                )
            }
            else -> result.notImplemented()
        }
    }
}
