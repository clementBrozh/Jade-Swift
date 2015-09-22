//
//  MapViewController.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 22/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initMap()
    }

    func initMap() {
        let rennesCoordinate = CLLocationCoordinate2D(latitude: 48.1119800, longitude: -1.6742900)
        let region = MKCoordinateRegion(center: rennesCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

        self.map.setRegion(region, animated: true)
    }
}

