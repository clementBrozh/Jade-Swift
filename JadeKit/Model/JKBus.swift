//
//  JKBus.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 22/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import Foundation
import MapKit

public class JKBus {

    public var coordinate:     CLLocationCoordinate2D
    public var lineShortName:  String
    public var destination:    String

    init(
        coordinate:     CLLocationCoordinate2D,
        lineShortName:  String,
        destination:    String
        )
    {
        self.coordinate     = coordinate
        self.lineShortName  = lineShortName
        self.destination    = destination
    }
}