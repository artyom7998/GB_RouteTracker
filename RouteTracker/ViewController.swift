//
//  ViewController.swift
//  RouteTracker
//
//  Created by Артем Зарудный on 02.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    private let coordinateMsk = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    private var coordinate = CLLocationCoordinate2D()
    private var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        coordinate = coordinateMsk
        configureMap()
        configureCoreLocation()
        updateLocation()
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
    }
    
    private func configureCoreLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
    private func updateLocation() {
        locationManager?.startUpdatingLocation()
    }
    
    private func centerLocation() {
        mapView.animate(toLocation: coordinate)
    }
    
    private func addMarker() {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
    
    private func markCurrentCoordinate(_ currentCoordinate: CLLocationCoordinate2D) {
        coordinate = currentCoordinate
        centerLocation()
        addMarker()
    }
    
    @IBAction func goToCenter(_ sender: Any) {
        coordinate = coordinateMsk
        centerLocation()
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            markCurrentCoordinate(location.coordinate)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
