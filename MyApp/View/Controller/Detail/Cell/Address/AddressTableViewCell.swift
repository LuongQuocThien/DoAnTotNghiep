//
//  AddressTableViewCell.swift
//  MyApp
//
//  Created by PCI0010 on 2/25/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import MVVM
import MapKit

final class AddressTableViewCell: UITableViewCell, View {

    // MARK: - Outlet
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!

    // MARK: - Properties
    var viewModel = AddressCellViewModel() {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configMapview()
    }

    private func configMapview() {
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
    }

    private func loadDataForMapView() {
        guard !mapView.annotations.contains(where: {
            return $0.coordinate.latitude == viewModel.coordinate.latitude
                && $0.coordinate.longitude == viewModel.coordinate.longitude }) else { return }
        let span = MKCoordinateSpan(latitudeDelta: Configure.zoomLatitude, longitudeDelta: Configure.zoomLongitude)
        mapView.region = MKCoordinateRegion(center: viewModel.coordinate, span: span)
        let annotation = MKPointAnnotation()
        annotation.coordinate = viewModel.coordinate
        mapView.addAnnotation(annotation)
    }

    private func updateView() {
        addressLabel.text = viewModel.address
        countryLabel.text = viewModel.country
        loadDataForMapView()
    }
}

// MARK: - MKMapViewDelegate
extension AddressTableViewCell: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude &&
            annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude else {
                return nil
        }
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Configure.identifier)
        pin.animatesDrop = true
        return pin
    }
}

extension AddressTableViewCell {

    struct Configure {
        static let zoomLatitude: Double = 0.01
        static let zoomLongitude: Double = 0.01
        static let identifier: String = "MKPinAnnotationView"
    }
}
