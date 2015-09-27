//
//  MapViewController.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 22/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import UIKit
import MapKit
import JadeKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initMap()
        self.loadBuses()
    }

    private func initMap() {
        let rennesCoordinate = CLLocationCoordinate2D(latitude: 48.1119800, longitude: -1.6742900)
        let region = MKCoordinateRegion(center: rennesCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

        self.map.setRegion(region, animated: true)
    }

    private func loadBuses() {
        SVProgressHUD.showWithStatus(NSLocalizedString("LOADING", comment: "Displayed in HUD"))
        JadeKit.getBusLive { (buses, error) in
            if let _ = error {
                SVProgressHUD.showErrorWithStatus(NSLocalizedString("LOADING_ERROR", comment: "Displayed in HUD"))
                return
            }

            for bus in buses {
                let annotation = MKPointAnnotation()
                annotation.title    = "Bus \(bus.lineShortName)"
                annotation.subtitle = "vers \(bus.destination)"
                annotation.coordinate = bus.coordinate
                self.map.addAnnotation(annotation)
            }
            SVProgressHUD.dismiss()
        }

    }
}