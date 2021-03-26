//
//  AiBarcodeScannerView.swift
//  ai_barcode
//
//  Created by JamesAir on 2020/1/19.
//

import Foundation
import AVFoundation
import Flutter
import MTBBarcodeScanner


class AiBarcodeScannerView:NSObject, FlutterPlatformView, FlutterStreamHandler {
    
    var scannerView: UIView!
    var scanner:MTBBarcodeScanner!
    var methodChannel:FlutterMethodChannel?;
    var eventChannel:FlutterEventChannel?;
    var flutterEventSink:FlutterEventSink?
    var binaryMessenger:FlutterBinaryMessenger!;
    /*
     Constructor.
     */
    init(binaryMessenger: FlutterBinaryMessenger) {
        //Call parent init constructor.
        super.init();
        self.binaryMessenger = binaryMessenger;
        /*
         Method Channel
         */
        initMethodChannel();
        /*
         Scanner
         */
        scannerView = UIView();
        //        scannerView.frame(forAlignmentRect: CGRect.init(x: 0, y: 0, width: 100, height: 150))
        scanner = MTBBarcodeScanner(previewView: scannerView);
    }
    
    
    
    func view() -> UIView {
        
        return scannerView;
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        flutterEventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        flutterEventSink = nil
        return nil
    } 
    
    func initMethodChannel(){
        /*
         MethodChannel.
         */
        methodChannel = FlutterMethodChannel.init(name: "view_type_id_scanner_view_method_channel", binaryMessenger: binaryMessenger)
        methodChannel?.setMethodCallHandler { (call :FlutterMethodCall, result:@escaping FlutterResult)  in
            
            switch(call.method){
            case "startCamera":
                self.startCamera();
                break;
            case "stopCamera":
                self.stopCamera();
                break;
            case "pauseCamera":
                self.pauseCamera();
                break;
            case "resumeCamera":
                self.resumeCamera();
                break;
            case "openFlash":
                self.openFlash();
                break;
            case "closeFlash":
                self.closeFlash();
                break;
            case "toggleFlash":
                self.toggleFlash();
                break;
            default:
                result("method:\(call.method) not implement");
            }
            result("succees");
        }
        eventChannel = FlutterEventChannel(name: "view_type_id_scanner_view_event_channel", binaryMessenger: binaryMessenger, codec: FlutterJSONMethodCodec.sharedInstance())  
        eventChannel?.setStreamHandler(self)
    }
    
    
    
    func startCamera(){
        if(self.scanner.isScanning()){
            return;
        }
        do {
            try self.scanner.startScanning(resultBlock: { codes in
                if let codes = codes {
                    for code in codes {
                        guard let stringValue = code.stringValue else { continue }
                        if (self.flutterEventSink != nil){
                            self.flutterEventSink?(["name":"onCodeFound", "code": stringValue])
                        }
                        
                        print("Found code: \(stringValue)")
                    }
                }
            })
        } catch {
            NSLog("Unable to start scanning error:\(error)")
        }
    }
    
    func stopCamera(){
        self.flutterEventSink = nil
        if(self.scanner.isScanning()){
            self.scanner.stopScanning()
        }
    }
    
    func pauseCamera(){
        if let sc: MTBBarcodeScanner = self.scanner {
            if sc.isScanning() {
                sc.freezeCapture()
            }
        }
    }

    func resumeCamera() {
        if let sc: MTBBarcodeScanner = self.scanner {
            if !sc.isScanning() {
                sc.unfreezeCapture()
            }
        }
    }

    func openFlash(){
        //        scanner?.setTorchMode(MTBTorchMode.on)
    }
    func closeFlash(){
        //        scanner?.setTorchMode(MTBTorchMode.off)
    }
    func toggleFlash(){
        scanner?.toggleTorch();
    }
}