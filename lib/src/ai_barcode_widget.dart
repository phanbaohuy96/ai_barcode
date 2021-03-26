part of '../ai_barcode.dart';

///
/// PlatformScannerWidget
///
/// Supported android and ios platform read barcode
// ignore: must_be_immutable
class PlatformAiBarcodeScannerWidget extends StatefulWidget {
  ///
  /// Controller.
  final ScannerController platformScannerController;

  final Function(String) onScanResult;
  final Function() onViewCreated;

  ///
  /// Constructor.
  const PlatformAiBarcodeScannerWidget({
    @required this.platformScannerController,
    this.onScanResult,
    this.onViewCreated,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlatformScannerWidgetState();
  }
}

///
/// _PlatformScannerWidgetState
class _PlatformScannerWidgetState
    extends State<PlatformAiBarcodeScannerWidget> {
//  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();

    final instance = AiBarcodeScannerPlatform.instance;
    //Create
    widget.platformScannerController.aiBarcodeScannerPlatform = instance;

    instance
      ..scannerResult = widget.onScanResult
      ..scannerViewCreated = widget.onViewCreated;
  }

  @override
  void didChangeDependencies() {
    final instance = AiBarcodeScannerPlatform.instance;
    //Create
    widget.platformScannerController.aiBarcodeScannerPlatform = instance;

    instance
      ..scannerResult = widget.onScanResult
      ..scannerViewCreated = widget.onViewCreated;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant PlatformAiBarcodeScannerWidget oldWidget) {
    final instance = AiBarcodeScannerPlatform.instance;
    //Create
    widget.platformScannerController.aiBarcodeScannerPlatform = instance;

    instance
      ..scannerResult = widget.onScanResult
      ..scannerViewCreated = widget.onViewCreated;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScannerPlatform.instance.buildScannerView(context);
  }
}

///
/// PlatformScannerController
class ScannerController {
  AiBarcodeScannerPlatform aiBarcodeScannerPlatform;

  bool get isStartCamera => aiBarcodeScannerPlatform.isStartCamera;
  bool get isPausedCamera => aiBarcodeScannerPlatform.isStoppedCamera;

  bool get isOpenFlash => aiBarcodeScannerPlatform.isOpenFlash;

  ///
  /// Start camera without open QRCode、BarCode scanner,this is just open camera.
  Future startCamera() {
    return aiBarcodeScannerPlatform.startCamera();
  }

  ///
  /// Stop camera.
  Future stopCamera() {
    return aiBarcodeScannerPlatform.stopCamera();
  }

  ///
  /// Pause camera
  Future pauseCamera() {
    return aiBarcodeScannerPlatform.pauseCamera();
  }

  ///
  /// Resume camera
  Future resumeCamera() {
    return aiBarcodeScannerPlatform.resumeCamera();
  }

  ///
  /// Open camera flash.
  Future openFlash() {
    return aiBarcodeScannerPlatform.openFlash();
  }

  ///
  /// Close camera flash.
  Future closeFlash() {
    return aiBarcodeScannerPlatform.closeFlash();
  }

  ///
  /// Toggle camera flash.
  Future toggleFlash() {
    return aiBarcodeScannerPlatform.toggleFlash();
  }
}
