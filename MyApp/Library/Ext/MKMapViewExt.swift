//
//  MKMapViewExt.swift
//  MyApp
//
//  Created by PCI0010 on 2/20/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import MapKit

extension MKMapView {

    func showRouteOnMap(destinationCoordinate: CLLocationCoordinate2D) {
        let pickupCoordinate = userLocation.coordinate
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        let destinationAnnotation = MKPointAnnotation()
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) -> Void in
            guard let response = response, let this = self else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            this.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            let edge = UIEdgeInsets(top: 75, left: 75, bottom: 75, right: 75)
            this.setVisibleMapRect(rect, edgePadding: edge, animated: true)
        }
    }
}
