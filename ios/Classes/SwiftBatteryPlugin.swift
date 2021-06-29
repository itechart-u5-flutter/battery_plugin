import Flutter
import UIKit
import CoreLocation

public class SwiftBatteryPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var currentLocation: String?
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "battery_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftBatteryPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "getCurrentLocation":
            print("getCurrentLocation was called")
            
            
            locationManager = CLLocationManager()
            locationManager?.requestAlwaysAuthorization()
           locationManager?.requestLocation()
            locationManager?.delegate = self
        default:
            result("not implemented")
        }
    }
}

// Step 5: Implement the CLLocationManagerDelegate to handle the callback from CLLocationManager
extension SwiftBatteryPlugin {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied: // Setting option: Never
            print("LocationManager didChangeAuthorization denied")
        case .notDetermined: // Setting option: Ask Next Time
            print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse: // Setting option: While Using the App
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
            
            // Stpe 6: Request a one-time location information
            locationManager?.requestLocation()
        case .authorizedAlways: // Setting option: Always
            print("LocationManager didChangeAuthorization authorizedAlways")
            
            // Stpe 6: Request a one-time location information
            locationManager?.requestLocation()
        case .restricted: // Restricted by parental control
            print("LocationManager didChangeAuthorization restricted")
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
    
    // Step 7: Handle the location information
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationManager didUpdateLocations: numberOfLocation: \(locations.count)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        locations.forEach { (location) in
            currentLocation = "LocationManager didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude), \(location.coordinate.longitude)"
            
            print("LocationManager altitude: \(location.altitude)")
            print("LocationManager didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude), \(location.coordinate.longitude)")
            print("LocationManager altitude: \(location.altitude)")
            print("LocationManager floor?.level: \(location.floor?.level)")
            print("LocationManager horizontalAccuracy: \(location.horizontalAccuracy)")
            print("LocationManager verticalAccuracy: \(location.verticalAccuracy)")
            print("LocationManager speed: \(location.speed)")
            print("LocationManager timestamp: \(location.timestamp)")
            print("LocationManager course: \(location.course)")
        }
    }

     public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("LocationManager didFailWithError \(error.localizedDescription)")
    if let error = error as? CLError, error.code == .denied {
       // Location updates are not authorized.
      // To prevent forever looping of `didFailWithError` callback
       locationManager?.stopMonitoringSignificantLocationChanges()
       return
    }
  }
}
