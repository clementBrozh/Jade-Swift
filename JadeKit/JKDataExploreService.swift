//
//  JKDataExploreService.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 22/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

class JKDataExploreService {

    static func getBusLive(completion: ([JKBus], NSError?) -> Void) {

        func parseApiResult(apiResult: AnyObject?) throws -> [JKBus]{
            guard let jsonResult = apiResult as? [String: AnyObject],
                let records = jsonResult["records"] as? [[String: AnyObject]] else
            {
                throw NSError(domain: "Unable to parse API result", code: 500, userInfo: nil)
            }
            
            var buses = [JKBus]()
            for record in records {
                if let fields = record["fields"] as? [String: AnyObject],
                    let lineShortName   = fields["nomcourtligne"] as? String,
                    let destination     = fields["destination"]   as? String,
                    let tmpCoordinate   = fields["coordonnees"]   as? [Double]
                {
                    let coordinate = CLLocationCoordinate2D(latitude: tmpCoordinate[0], longitude: tmpCoordinate[1])
                    let bus = JKBus(coordinate: coordinate, lineShortName: lineShortName, destination: destination)
                    buses.append(bus)
                }
            }
            return buses
        }

        let parameters = [
            "dataset": "tco-bus-vehicules-position-tr",
            "rows": 50,
            "sort": "idbus",
            "refine.etat": "En ligne",
            "apikey": "6743173718756f8c664487c1d62be6f082f5f4331004056234038e71"
        ]

        Alamofire.request(.GET, "https://data.explore.star.fr/api/records/1.0/search", parameters: parameters)
            .responseJSON { (request, response, result) -> Void in
                do {
                    let buses = try parseApiResult(result.value)
                    completion(buses, nil)
                } catch let error as NSError {
                    completion([], error)
                }

        }
    }

}