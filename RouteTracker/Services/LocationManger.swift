//
//  LocationManger.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 18.11.2021.
//

import Foundation
import CoreLocation
import RxSwift

class LocationManger: NSObject{
    
    static let shared = LocationManger()
    
    private override init() {
        super.init()
        config()
    }
    
    let locationManager = CLLocationManager()
    let location = PublishSubject<CLLocation?>()
    
    func startUpdating() {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    private func config() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManger: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location.onNext(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
