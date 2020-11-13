//
//  SearchPointAnotation.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 3/2/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import Foundation
import MapKit

final class SearchPointAnnotation: NSObject, MKAnnotation {

    // MARK: - Properties
    var id: String
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var imageUrlString: String
    var imagePin: UIImage?

    // MARK: - Init
    init(id: String, coordinate: CLLocationCoordinate2D, title: String, subtitle: String, imageUrlString: String, imagePin: UIImage) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.imageUrlString = imageUrlString
        self.subtitle = subtitle
        self.imagePin = imagePin
    }
}
