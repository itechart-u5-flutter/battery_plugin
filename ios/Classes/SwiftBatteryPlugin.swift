import Flutter
import UIKit
import CoreLocation

public class SwiftBatteryPlugin: NSObject, FlutterPlugin {
    var locationManager = CLLocationManager()
    var currenLocationLat: String?
    var resultClosure: FlutterResult?
    
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
        
        locationManager.delegate = self
        resultClosure = result
        
        switch (call.method) {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "askPermissionAndStartLocation":
            print("askPermissionAndStartLocation was called")
            if #available(iOS 14.0, *) {
              let status =  locationManager.authorizationStatus
                if (status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways) {
                    result(true);
                }
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
            
        case "getCurrentLocation":
            locationManager.requestLocation()
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
            if let result = self.resultClosure {
                let locationString = "Result didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude), \(location.coordinate.longitude)"
                result(locationString)
            }
            
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
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let result = resultClosure else {
            return
        }
        switch status {
        case .denied: // Setting option: Never
            print("LocationManager didChangeAuthorization denied")
           result(false)
        case .notDetermined: // Setting option: Ask Next Time
            print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse: // Setting option: While Using the App
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
            result(true)
           
        case .authorizedAlways: // Setting option: Always
            print("LocationManager didChangeAuthorization authorizedAlways")
            result(true)
           
        case .restricted: // Restricted by parental control
            print("LocationManager didChangeAuthorization restricted")
            result(false)
        default:
            print("LocationManager didChangeAuthorization")
            result(false)
        }
    }
}
