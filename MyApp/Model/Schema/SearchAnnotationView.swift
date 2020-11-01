//
//  SearchAnnotationView.swift
//  MyApp
//
//  Created by TAN HUYNH on 3/2/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
final class SearchAnnotationView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let point = newValue as? SearchPointAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            leftImageView.setImageWithURL(point.imageUrlString)
            leftCalloutAccessoryView = leftImageView
            glyphImage = point.imagePin
        }
    }
}
