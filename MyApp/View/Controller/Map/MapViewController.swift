//
//  MapViewController.swift
//  MyApp
//
//  Created by PCI0010 on 2/15/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {

    // MARK: - Outlet
    @IBOutlet private weak var mapView: MKMapView!

    // MARK: - Properties
    var viewModel = MapViewModel()
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataMapView()
        configLocationServices()
        configNavi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationManager.shared.startStandardLocationService()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LocationManager.shared.stopStandardLocationService()
    }

    // MARK: - Private
    private func configLocationServices() {
//        LocationManager.shared.configLocationService()
    }

    func loadDataMapView() {
        mapView.showsUserLocation = true
            let span = MKCoordinateSpan(latitudeDelta: Configure.zoomLatitude, longitudeDelta: Configure.zoomLongitude)
            mapView.region = MKCoordinateRegion(center: viewModel.coordinate, span: span)
            let annotation = PointAnnotation(coordinate: viewModel.coordinate, title: viewModel.name, subtitle: viewModel.address)
            mapView.addAnnotation(annotation)
            mapView.delegate = self
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction private func directButtonTouchUpInsde(_ sender: UIButton) {
        mapView.showRouteOnMap(destinationCoordinate: viewModel.coordinate)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        mapView.removeOverlays(mapView.overlays)
    }

    private func configNavi() {
        title = viewModel.name
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PointAnnotation else { return nil }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Configure.identifier)
        if pinView == nil {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: Configure.identifier)
            pinView?.canShowCallout = true
            pinView?.calloutOffset = CGPoint(x: 0, y: 0)
            pinView?.contentMode = .scaleAspectFill
            pinView?.image = #imageLiteral(resourceName: "location1")
            if let thumbnail = viewModel.thumbnail {
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                image.setImageWithURL(thumbnail)
                pinView?.leftCalloutAccessoryView = image
            }
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = Configure.lineWidth
        return renderer
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.removeOverlays(mapView.overlays)
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        guard let annotation = mapView.annotations.first as? PointAnnotation else { return }
        mapView.selectAnnotation(annotation, animated: true)
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        return
    }
}

// MARK: - Config
extension MapViewController {

    struct Configure {
        static let lineWidth: CGFloat = 1.0
        static let identifier: String = "pin"
        static let zoomLatitude: Double = 0.02
        static let zoomLongitude: Double = 0.02
        static let frameImage = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
}
