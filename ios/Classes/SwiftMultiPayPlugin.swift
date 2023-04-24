import Flutter
import UIKit
import MercadoPagoSDK

public class SwiftMultiPayPlugin: NSObject, FlutterPlugin, PXLifeCycleProtocol {
    var pendingResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar){
        let channel = FlutterMethodChannel(name: "multipay", binaryMessenger: registrar.messenger())

        let instance = SwiftMultiPayPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        if(call.method == "getPlatformVersion"){
            result("iOS " + UIDevice.current.systemVersion)
        } else if (call.method == "startCheckout") {
            let args = call.arguments as! Dictionary<String, String>
            let publicKey = args["publicKey"] ?? ""
            let preferenceId = args["preferenceId"] ?? ""

            pendingResult = result

            startCheckout(publicKey: publicKey, preferenceId: preferenceId)
        } else {
            handleNavigationBar(isMercadoPagoActive: false)
            result(FlutterMethodNotImplemented)
        }
    }

    public func startCheckout(publicKey: String, preferenceId: String){
        
    }
}