//
//  MapViewController.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 22/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import JadeKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!

    var busesAnnotations = [MapAnnotation]()
    var stopsAnnotations = [MapAnnotation]()

    var managedObjectContext: NSManagedObjectContext!{
        return (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    }

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
                let title    = "Bus \(bus.lineShortName)"
                let subtitle = "vers \(bus.destination)"
                let coordinate = bus.coordinate
                let annotation = MapAnnotation(
                    coordinate: coordinate,
                    title: title,
                    subtitle: subtitle,
                    type: .Bus)
                self.busesAnnotations.append(annotation)
            }
            self.map.addAnnotations(self.busesAnnotations)
            SVProgressHUD.dismiss()
        }
    }

    private func loadStops() {
        
        var stops: [Stop]
        do {
            stops = try self.getStopsFromCoreData()
            if stops.isEmpty {
                try GTFSParser().parseStops()
                stops = try self.getStopsFromCoreData()
            }
        } catch _ as NSError {
            SVProgressHUD.showErrorWithStatus(NSLocalizedString("GET_STOPS_ERROR", comment: "Shown on HUD when core data request failed"))
            return
        }

        for stop in stops {
            let title    = stop.name
            let subtitle = ""
            let coordinate = CLLocationCoordinate2D(latitude: Double(stop.latitude), longitude: Double(stop.longitude))
            let annotation = MapAnnotation(
                coordinate: coordinate,
                title: title,
                subtitle: subtitle,
                type: .Stop)
            self.stopsAnnotations.append(annotation)
        }
        self.map.addAnnotations(self.stopsAnnotations)
    }

    private func getStopsFromCoreData() throws -> [Stop] {

        let fetch = NSFetchRequest(entityName: "Stop")
        fetch.predicate = NSPredicate(format: "name contains[c] ' c'")
        let stopsFromCoreData = try managedObjectContext.executeFetchRequest(fetch) as [AnyObject]!
        guard let stops = stopsFromCoreData as? [Stop] else {
            throw NSError(domain: "Unable to get stops from core data", code: 500, userInfo: nil)
        }
        return stops
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{

        guard let senderAnnotation = annotation as? MapAnnotation else{
            return nil
        }

        let pinReusableIdentifier = senderAnnotation.type.rawValue
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(pinReusableIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: senderAnnotation, reuseIdentifier: pinReusableIdentifier)
            annotationView!.canShowCallout = true
        }

        let annotationImage = senderAnnotation.type.image
        annotationView!.image = annotationImage

        return annotationView
        
    }

    @IBAction func showStopsAction(sender: AnyObject) {
        if self.stopsAnnotations.isEmpty {
            self.loadStops()
        } else {
            self.map.removeAnnotations(self.stopsAnnotations)
            self.stopsAnnotations.removeAll()
        }
    }

    @IBAction func refreshBusesAction(sender: AnyObject) {

        self.map.removeAnnotations(self.busesAnnotations)
        self.busesAnnotations.removeAll()

        self.loadBuses()
    }
}