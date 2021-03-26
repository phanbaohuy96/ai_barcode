import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ai_barcode_platform_interface.dart';
import 'ai_barcode_mobile_scanner_plugin.dart';

enum CameraState { starting, stopped, paused }
enum FlashState { open, closed }

/// AiBarcodeScannerPlatform
abstract class AiBarcodeScannerPlatform extends ChangeNotifier
    with AiBarcodePlatform {
  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is
  /// forbidden for anything other than mocks (see class docs).
  /// This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  static AiBarcodeScannerPlatform _instance = AiBarcodeMobileScannerPlugin();

  CameraState _cameraState = CameraState.stopped;
  FlashState _flashState = FlashState.closed;

  /// The default instance of [AiBarcodeScannerPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [AiBarcodeScannerPlatform] when they
  /// register themselves.
  ///
  static AiBarcodeScannerPlatform get instance => _instance;

  ///
  /// Whether start camera
  bool get isStartCamera => _cameraState == CameraState.starting;

  ///
  /// Whether start camera preview or start to recognize
  bool get isStoppedCamera => _cameraState == CameraState.stopped;

  bool get isPauseCamera => _cameraState == CameraState.paused;

  ///
  /// Whether open the flash
  bool get isOpenFlash => _flashState == FlashState.open;

  String _unsupportedPlatformDescription =
      'Unsupported platforms, working hard to support';

  String get unsupportedPlatformDescription => _unsupportedPlatformDescription;

  set unsupportedPlatformDescription(String text) {
    if (text == null || text.isEmpty) {
      return;
    }
    _unsupportedPlatformDescription = text;
  }

  ///
  /// Instance update
  static set instance(AiBarcodeScannerPlatform instance) {
    if (!instance.isMock) {
      try {
        instance._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = instance;
  }

  /// Returns a widget displaying.
  Widget buildScannerView(BuildContext context) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  ///
  /// View created of scanner widget
  void onPlatformScannerViewCreated(int id) {
    scannerViewCreated?.call();
  }

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  Future<void> startCamera() async {
    _cameraState = CameraState.starting;
    await AiBarcodePlatform.methodChannelScanner.invokeMethod('startCamera');
    listenEventChannel();
  }

  ///
  /// Stop camera.
  Future stopCamera() async {
    _cameraState = CameraState.stopped;
    return AiBarcodePlatform.methodChannelScanner.invokeMethod('stopCamera');
  }

  ///
  /// Start camera preview with open QRCode、BarCode scanner,
  /// this is open code scanner.
  Future<String> resumeCamera() {
    _cameraState = CameraState.starting;
    return AiBarcodePlatform.methodChannelScanner.invokeMethod('resumeCamera');
  }

  ///
  /// Stop camera preview.
  Future pauseCamera() {
    _cameraState = CameraState.paused;
    return AiBarcodePlatform.methodChannelScanner.invokeMethod('pauseCamera');
  }

  ///
  /// Open camera flash.
  Future openFlash() {
    _flashState = FlashState.open;
    return AiBarcodePlatform.methodChannelScanner.invokeMethod('openFlash');
  }

  ///
  /// Close camera flash.
  Future closeFlash() {
    _flashState = FlashState.closed;
    return AiBarcodePlatform.methodChannelScanner.invokeMethod('closeFlash');
  }

  ///
  /// Toggle camera flash.
  Future toggleFlash() {
    _flashState =
        _flashState == FlashState.open ? FlashState.closed : FlashState.open;
    return AiBarcodePlatform.methodChannelScanner.invokeMethod('toggleFlash');
  }

  // This method makes sure that AiBarcode isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter,
  // which fails if the class is implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}

  void listenEventChannel() {
    const EventChannel(
      'view_type_id_scanner_view_event_channel',
      JSONMethodCodec(),
    ).receiveBroadcastStream().listen(_receiveBroadcastStream);
  }

  StreamSubscription<dynamic> _receiveBroadcastStream(dynamic event) {
    final eventName = event['name'];
    switch (eventName) {

      /* onCodeFound */
      case 'onCodeFound':
        scannerResult?.call(event['code'].toString());
        break;

      default:
        break;
    }
    return null;
  }

  ///
  /// Result
  Function(String result) scannerResult;
  Function() scannerViewCreated;
}
