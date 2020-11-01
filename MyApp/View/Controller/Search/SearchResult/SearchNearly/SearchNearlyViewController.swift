//
//  SearchNearlyViewController.swift
//  MyApp
//
//  Created by PCI0001 on 2/28/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MapKit

final class SearchNearlyViewController: ViewController, UIGestureRecognizerDelegate {

    // MARK: - Outlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = SearchNearlyViewModel()
    var zoomFirstTime = true

    // MARK: - Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configLocationServices()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LocationManager.shared.startStandardLocationService()
        searchNearly(query: viewModel.query)
    }

    // MARK: - Private
    private func setupUI() {
        configTableView()
        configMapView()
    }

    func searchNearly(query: String) {
        viewModel.searchNearly(query: query) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.reloadAnnotationForMapView()
                this.tableView.reloadData()
                this.setVisibleAtSearchingLocation()
            case .failure(let error):
                this.alert(error: error)
            }
        }
    }

    func searchWhenTouchInMap() {
        viewModel.searchNearly(query: viewModel.query) { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.tableView.reloadData()
                this.reloadAnnotationsWhenTouchInMap()
            case .failure(let error):
                this.alert(error: error)
            }
        }
    }

    func searchWithFilter(categorieIds: [String]) {
        viewModel.updateCategoryId(categoryIds: categorieIds)
        searchNearly(query: viewModel.query)
    }

    private func configTableView() {
        tableView.register(SearchTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self

        let foosterView = Bundle.main.loadNibNamed("FoosterTableView", owner: self, options: nil)?[0] as? FoosterTableView
        foosterView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
        guard let fooster = foosterView else { return }
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        tableView.tableFooterView?.addSubview(fooster)
    }

    // MARK: - LocationService & MapView
    private func configLocationServices() {
        LocationManager.shared.configLocationService()
        LocationManager.shared.delegate = self
    }

    private func configMapView() {
        mapView.showsUserLocation = true
        if #available(iOS 11.0, *) {
            mapView.register(SearchAnnotationView.self, forAnnotationViewWithReuseIdentifier: Config.annotationViewIdentifier)
        }
        mapView.delegate = self
    }

    private func reloadAnnotationForMapView() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        mapView.addAnnotations(viewModel.getAnnotations())
        guard let coordinate = viewModel.searchingLocation else { return }
        let circle = MKCircle(center: coordinate, radius: viewModel.radiusSearch as CLLocationDistance)
        mapView.addOverlay(circle)
        mapView.reloadInputViews()
    }

    private func reloadAnnotationsWhenTouchInMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        let pointSearchAnno = MKPointAnnotation()
        guard let coordinate = viewModel.searchingLocation else { return }
        pointSearchAnno.coordinate = coordinate
        mapView.addAnnotation(pointSearchAnno)
        mapView.addAnnotations(viewModel.getAnnotations())

        let circle = MKCircle(center: coordinate, radius: viewModel.radiusSearch as CLLocationDistance)
        mapView.addOverlay(circle)
        mapView.reloadInputViews()
    }

    private func setVisibleAtSearchingLocation() {
        guard let coordinate = viewModel.searchingLocation else { return }
        let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Config.zoomLatitude, longitudeDelta: Config.zoomLongitude)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
    }

    @IBAction private func returnUserLocationButtonTouchUpInside(_ sender: UIButton) {
        viewModel.searchingLocation = mapView.userLocation.coordinate
        searchNearly(query: viewModel.query)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissKeyboard()
    }
}

// MARK: - Extension UITableViewDataSource
extension SearchNearlyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SearchTableViewCell.self)
        let vm = viewModel.viewModelForItem(at: indexPath)
        cell.viewModel = vm
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightForRow
    }
}

// MARK: - Extension UITableViewDelegate
extension SearchNearlyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.saveRestaurantRealm(at: indexPath)
        let vc = DetailViewController()
        vc.viewModel = viewModel.getDetailViewModel(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extension MKMapViewDelegate
extension SearchNearlyViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is SearchPointAnnotation {
            if #available(iOS 11.0, *) {
                let searchAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Config.annotationViewIdentifier)
                searchAnnotationView?.annotation = annotation
                return searchAnnotationView
            } else {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Config.annotationViewIdentifier)
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Config.annotationViewIdentifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                if let customPointAnnotation = annotation as? SearchPointAnnotation {
                    let imageUrlString = customPointAnnotation.imageUrlString
                    let imageView = UIImageView(frame: Config.frameImage)
                    imageView.setImageWithURL(imageUrlString)
                    annotationView?.leftCalloutAccessoryView = imageView
                    annotationView?.image = #imageLiteral(resourceName: "location1")
                }
                return annotationView
            }
        } else if annotation is MKPointAnnotation {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Config.pinIdentifier)
            pin.animatesDrop = true
            pin.pinTintColor = .green
            return pin
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? SearchPointAnnotation else { return }
        viewModel.saveRestaurantWithIdRealm(id: annotation.id)
        let vc = DetailViewController()
        vc.viewModel = viewModel.getDetailViewModelWhenTapCallOut(id: annotation.id)
        navigationController?.pushViewController(vc, animated: true)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.fillColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1).withAlphaComponent(0.2)
            circle.lineWidth = 0
            return circle
        } else {
            return MKOverlayRenderer()
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if zoomFirstTime {
            guard mapView.selectedAnnotations.isEmpty,
                Double(round(1000 * mapView.region.span.latitudeDelta) / 1000) == Config.zoomLatitude else { return }
            zoomFirstTime = false
        }
        viewModel.searchingLocation = mapView.region.center
        searchWhenTouchInMap()
    }
}

// MARK: - Extension LocationManager
extension SearchNearlyViewController: LocationManagerDelegate {

    func manager(manager: LocationManager, needsPerformAction action: LocationManager.Action) {
        switch action {
        case .finishUpdatingLocation(let location, _):
            viewModel.searchingLocation = location.coordinate
            searchNearly(query: viewModel.query)
            LocationManager.shared.stopStandardLocationService()
        case .denied:
            print("Deny")
        }
    }
}

// MARK: - Config
extension SearchNearlyViewController {

    struct Config {
        static let heightForRow: CGFloat = 70
        static let heightForTableView = UIScreen.main.bounds.height / 2
        static let lineWidth: CGFloat = 5.0
        static let annotationViewIdentifier = "SearchAnnotationView"
        static let zoomLatitude: Double = 0.006
        static let zoomLongitude: Double = 0.006
        static let frameImage = CGRect(x: 0, y: 0, width: 50, height: 50)
        static let pinIdentifier = "MKPinAnnotationView"
    }
}
