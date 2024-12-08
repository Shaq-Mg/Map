//
//  ViewController.swift
//  Map
//
//  Created by Shaquille McGregor on 07/12/2024.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.layer.cornerRadius = 10
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.backgroundColor = UIColor.white
        searchTextField.placeholder = "Search..."
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: initialize location manager
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(mapView)
        
        view.bringSubviewToFront(searchTextField)
        
        // MARK: constraints to serarch textfield
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        searchTextField.returnKeyType = .go
        
        // MARK: constraints to mapView
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
            mapView.setRegion(region, animated: true)
        case .notDetermined, .restricted:
            print("Location cannot be determined or restricted.")
        case .denied:
            print("Location services has been denied.")
        @unknown default:
            print("Unknown error. Unable to get location.")
        }
    }
    
    private func findNearbyPlaces(by query: String) {
        
        // clear all annotations
        mapView.removeAnnotation(mapView.annotations)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else { return }
            print(response.mapItems)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        textField.resignFirstResponder()
        
        // find nearby places
        findNearbyPlaces(by: text)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
