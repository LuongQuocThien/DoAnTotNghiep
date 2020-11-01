//
//  PointAnnotation.swift
//  MyApp
//
//  Created by PCI0010 on 2/18/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import MapKit

final class PointAnnotation: NSObject, MKAnnotation {

    // MARK: - Properties
    var id: Int?
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: String?
    var subtitle: String?

    // MARK: - Init
    init(id: Int? = nil, coordinate: CLLocationCoordinate2D, title: String? = nil, image: String? = nil, subtitle: String? = nil) {
        self.id = id
        self.coordinate = coordinate
        self.title = title
        self.image = image
        self.subtitle = subtitle
    }
}
