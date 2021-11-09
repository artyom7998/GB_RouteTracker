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
    private let realmService = RealmService()
    private var coordinate = CLLocationCoordinate2D()
    private var locationManager: CLLocationManager?
    private var executeRouteTracking: Bool = false
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCoreLocation()
        locationManager?.requestLocation()
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
    }
    
    private func configureCoreLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func centerLocation() {
        mapView.animate(toLocation: coordinate)
    }
    
    private func startRouteTracking() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
        locationManager?.startMonitoringSignificantLocationChanges()
    }
    
    private func stopRouteTracking() {
        locationManager?.stopUpdatingLocation()
        locationManager?.stopMonitoringSignificantLocationChanges()
        guard let routePath = routePath else { return }
        
        let count = routePath.count()-1
        var coordinatesPath = [CoordinatePath]()
        
        do {
            try realmService.deleteAllClassObjects(CoordinatePath())
        } catch {
            print(error)
        }
        
        for pathIndex in 0...count where pathIndex >= 0 {
            let coordinateAtIndex = routePath.coordinate(at: UInt(pathIndex))
            let coordinatePathAtIndex = CoordinatePath(Int(pathIndex), coordinateAtIndex.latitude, coordinateAtIndex.longitude)
            coordinatesPath.append(coordinatePathAtIndex)
        }
        
        do {
            try realmService.save(items: coordinatesPath)
        } catch {
            print(error)
        }
    }

    private func updateRoutePath(_ currentCoordinate: CLLocationCoordinate2D) {
        coordinate = currentCoordinate
        configureMap()
        centerLocation()
        routePath?.add(coordinate)
        route?.path = routePath
    }
    
    private func routeTrackingStartStop() {
        switch executeRouteTracking {
        case true:
            stopRouteTracking()
        case false:
            startRouteTracking()
        }
        executeRouteTracking = !executeRouteTracking
    }
    
    private func showLastRouteTrackWithQuestion() {
        switch executeRouteTracking {
        case true:
            showAlertToStopTrack()
        case false:
            showLastRouteTrack()
        }
    }
    
    private func showLastRouteTrack() {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        var gmsBounds = GMSCoordinateBounds()
        
        let coordinatesPatch = realmService.load(CoordinatePath())
        coordinatesPatch.forEach { CoordinatePath in
            let coordinatePatch = CLLocationCoordinate2D(latitude: CoordinatePath.lat, longitude: CoordinatePath.lon)
            routePath?.add(coordinatePatch)
            gmsBounds = gmsBounds.includingCoordinate(coordinatePatch)
        }
        route?.path = routePath
        mapView.animate(with: GMSCameraUpdate.fit(gmsBounds, withPadding: 30.0))
    }
    
    private func showAlertToStopTrack() {
        let alertController = UIAlertController(title: "Ведется отслеживание маршрута", message: "В настоящий момент ведется отслеживание маршрута. Остановить?", preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ок", style: UIAlertAction.Style.default) {UIAlertAction in
            self.routeTrackingStartStop()
            self.showLastRouteTrack()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel)
        alertController.addAction(oKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showActions(_ sender: Any) {
        let alertController = UIAlertController(title: "Действия", message: "Отслеживание и отображение маршрута", preferredStyle: .actionSheet)
        
        let titleAction = self.executeRouteTracking ? "Остановить отслеживание маршурта" : "Начать отслеживание маршурта"
        let styleAction = self.executeRouteTracking ? UIAlertAction.Style.destructive : UIAlertAction.Style.default
        let routeTrackingStartStopAction = UIAlertAction(title: titleAction, style: styleAction) { UIAlertAction in
            self.routeTrackingStartStop()
        }
        
        let showTrackAction = UIAlertAction(title: "Отобразить предыдущий маршрут", style: UIAlertAction.Style.default) { UIAlertAction in
            self.showLastRouteTrackWithQuestion()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.cancel)
        
        alertController.addAction(routeTrackingStartStopAction)
        alertController.addAction(showTrackAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        locations.forEach { location in
            updateRoutePath(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
