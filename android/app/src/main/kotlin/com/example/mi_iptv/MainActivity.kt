package com.example.mi_iptv

import com.example.mi_iptv.oem.OemCompatibilityPlugin
import com.example.mi_iptv.player.Media3PlayerPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // TV-050: Media3 host lives on the engine, not on Flutter player screens.
        flutterEngine.plugins.add(Media3PlayerPlugin())
        // TV-011: OEM fingerprint (manufacturer / model / API) for compatibility profiles.
        flutterEngine.plugins.add(OemCompatibilityPlugin())
    }
}
