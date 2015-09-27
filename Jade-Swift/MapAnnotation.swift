//
//  MapAnnotation.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 27/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import UIKit
import MapKit

enum MapAnnotationType: String {
    case Bus  = "Bus"
    case Stop = "Stop"

    var image: UIImage {
        switch self {
        case .Bus:
            return UIImage(named: "BusPinImage")!
        case .Stop:
            return UIImage(named: "StopPinImage")!
        }
    }
}

class MapAnnotation: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: MapAnnotationType

    init(coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String?,
        type: MapAnnotationType){
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
            self.type = type
            super.init()
    }

    convenience init(coordinate: CLLocationCoordinate2D,
        title: String,
        subtitle: String){
            self.init(coordinate: coordinate,
                title: title,
                subtitle: subtitle,
                type: .Bus)
    }
}
