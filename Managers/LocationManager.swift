//
//  LocationManager.swift
//  Map
//
//  Created by Shaquille McGregor on 07/12/2024.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let mapView = MKMapView()
    var locationManager: CLLocationManager?
    
    override init() {
        super.init()


    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .notDetermined:
            print("")
        case .restricted:
            print("")
        case .denied:
            print("")
        @unknown default:
            print("")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
