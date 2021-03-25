package com.air.ai_barcode

import android.content.Context
import android.util.Log
import android.view.View
import com.air.ai_barcode.custom_zxing_scanner.MyScannerView
import com.google.zxing.Result
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import org.json.JSONObject

/**
 * <p>
 * Created by air on 2019-12-02.
 * </p>
 */
class AndroidScannerView(binaryMessenger: BinaryMessenger, context: Context, viewid: Int, args: Any?) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, MyScannerView.ResultHandler {


    /**
     * 用于向Flutter发送数据
     */
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventChannelSink = events

        val message = JSONObject()
        message.put("name", "onListen")
        this.eventChannelSink?.success(message)
    }

    override fun onCancel(arguments: Any?) {
        this.eventChannelSink = null
    }

    /**
     * 识别二维码结果
     */
    override fun handleResult(rawResult: Result?) {
        val message = JSONObject()

        message.put("name", "onCodeFound")
        message.put("code", rawResult.toString())

        this.eventChannelSink?.success(message)
    }

    /**
     * 接收Flutter传递过来的数据据
     */
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {
            "startCamera" -> startCamera()
            "stopCamera" -> stopCamera()
            "resumeCameraPreview" -> resumeCameraPreview()
            "stopCameraPreview" -> stopCameraPreview()
            "openFlash" -> openFlash()
            "closeFlash" -> closeFlash()
            "toggleFlash" -> toggleFlash()
            else -> result.notImplemented()
        }
        result.success("success")
    }

    /**
     * 二维码扫描组件
     */
    var zxing: MyScannerView = MyScannerView(context);


    var eventChannelSink: EventChannel.EventSink? = null;

    init {
        Log.d("AndroidScannerView", "init")

        /*
        MethodChannel
         */
        MethodChannel(binaryMessenger, "view_type_id_scanner_view_method_channel").setMethodCallHandler(this);
        /*
        EventChannel
         */
        EventChannel(binaryMessenger, "view_type_id_scanner_view_event_channel", JSONMethodCodec.INSTANCE).setStreamHandler(this)
    }

    override fun getView(): View {
        zxing.setAutoFocus(true);
        zxing.setAspectTolerance(0.5f);
        return zxing;
    }

    override fun dispose() {
        Log.d("AndroidScannerView", "dispose")
    }

    override fun onFlutterViewDetached() {
    }


    override fun onFlutterViewAttached(flutterView: View) {
        Log.d("AndroidScannerView", "onFlutterViewAttached")
    }

    private fun startCamera() {
        zxing.startCamera();
    }

    private fun stopCamera() {
        zxing.stopCamera();
    }

    private fun resumeCameraPreview() {
        zxing.resumeCameraPreview(this);
    }

    private fun stopCameraPreview() {
        zxing.stopCameraPreview();
    }

    private fun openFlash() {
        zxing.flash = true;
    }

    private fun closeFlash() {
        zxing.flash = false;
    }

    private fun toggleFlash() {
        zxing.toggleFlash();
    }
}