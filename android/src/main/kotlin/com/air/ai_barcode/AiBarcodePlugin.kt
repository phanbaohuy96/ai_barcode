package com.air.ai_barcode

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding

/** AiBarcodePlugin */
 class AiBarcodePlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        binding.platformViewRegistry.registerViewFactory("view_type_id_scanner_view", AndroidScannerViewFactory(binding.binaryMessenger));
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}
}
