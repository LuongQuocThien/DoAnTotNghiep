//
//  LocationManager.swift
//  MyApp
//
//  Created by PCI0010 on 2/19/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import CoreLocation
import UIKit

protocol LocationManagerDelegate: class {
    func manager(manager: LocationManager, needsPerformAction action: LocationManager.Action)
}

final class LocationManager: NSObject {

    enum Action {
        case finishUpdatingLocation(location: CLLocation, name: String)
        case denied
    }

    private lazy var clLocationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    static let shared: LocationManager = {
        return LocationManager()
    }()

    private override init() {
        super.init()
        clLocationManager.delegate = self
    }

    func configLocationService() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            clLocationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            enableLocationServices()
            startStandardLocationService()
        case .denied:
            let title = App.Map.title
            let message = App.Map.msg
            UIApplication.shared.keyWindow?.rootViewController?.showAlert(title: title, message: message, buttons: ["OK"], handler: nil)
        case .restricted:
            break
        }
    }

    private func enableLocationServices() {
        CLLocationManager.locationServicesEnabled()
    }

    func startStandardLocationService() {
        clLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        clLocationManager.distanceFilter = 0
        clLocationManager.startUpdatingLocation()
    }

    func stopStandardLocationService() {
        clLocationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            stopStandardLocationService()
        case .authorizedAlways, .authorizedWhenInUse:
            enableLocationServices()
            startStandardLocationService()
        case .notDetermined:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentlat = manager.location?.coordinate.latitude, let cuurentlong = manager.location?.coordinate.longitude else { return }
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentlat, longitude: cuurentlong)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, _) -> Void in
            guard let placemarks = placemarks, let this = self else { return }
            if !placemarks.isEmpty {
                guard let city = placemarks[0].addressDictionary?["City"] as? String,
                    let country = placemarks[0].addressDictionary?["Country"] as? String else { return }
                this.delegate?.manager(manager: this, needsPerformAction: .finishUpdatingLocation(location: location, name: "\(city), \(country)"))
            }
        })
    }
}
