import Flutter
import UIKit
import CoreLocation

public class SwiftBatteryPlugin: NSObject, FlutterPlugin {
    var locationManager = CLLocationManager()
    var currenLocationLat: String?
    
    
    
    var channel :FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "battery_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftBatteryPlugin(channel: channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //        print(call.arguments)
        //        let args = call.arguments as? NSDictionary
        //        guard let args = args else {
        //            return result("Error")
        //        }
        
        switch (call.method) {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "askPermissionAndStartLocation":
            print("askPermissionAndStartLocation was called")
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            result("askPermissionAndStartLocation end")
            
        case "getCurrentLocation":
            print("getCurrentLocation was called")
            if  let args = call.arguments  {
                print("args - \(args)")
                result(args)
            }
        default:
            result("not implemented")
        }
    }
}


extension SwiftBatteryPlugin: CLLocationManagerDelegate {
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        locations.forEach { (location) in
            let locationString = "Result didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude), \(location.coordinate.longitude)"
            let resultLocation: FlutterResult = { (result) in
                print("let resultLocation: FlutterResult = \(result)")
                result
                //                locationString
            }
            self.handle(FlutterMethodCall(methodName: "getCurrentLocation", arguments: locationString), result: resultLocation)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            self.locationManager.stopMonitoringSignificantLocationChanges()
            return
        }
    }
}
