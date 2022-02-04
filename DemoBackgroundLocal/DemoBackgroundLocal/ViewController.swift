//
//  ViewController.swift
//  DemoBackgroundLocal
//
//  Created by 김수완 on 2022/02/04.
//

import UIKit

import MapKit
import LocalConsole

class ViewController: UIViewController {
    
    let consoleManager = LCManager.shared

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recordSwitch: UISwitch!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConsole()
        setupLocationManager()
        setupMapView()
    }

    @IBAction func recordSwitch(_ sender: Any) {
        if recordSwitch.isOn {
            consoleManager.print("기록 시작")
            locationManager.startUpdatingLocation()
        } else {
            consoleManager.print("기록 중지")
            locationManager.stopUpdatingLocation()
        }
    }

}

extension ViewController {
    private func setupConsole() {
        consoleManager.isVisible = true
        consoleManager.fontSize = 5
    }
}

extension ViewController: MKMapViewDelegate {

    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }

}

extension ViewController: CLLocationManagerDelegate {

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }

    private func addAnnotation(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees
    ) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        mapView.addAnnotation(annotation)
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        let lastLocation = locations.last
        let latitude = lastLocation?.coordinate.latitude
        let longitude = lastLocation?.coordinate.longitude

        consoleManager.print(lastLocation!)
        addAnnotation(latitude: latitude!, longitude: longitude!)

        CLGeocoder().reverseGeocodeLocation(lastLocation!) { placemarks, _ in
            self.title = "\(placemarks?.first?.country ?? "") \(placemarks?.first?.locality ?? "") \(placemarks?.first?.thoroughfare ?? "")"
        }
    }

}
