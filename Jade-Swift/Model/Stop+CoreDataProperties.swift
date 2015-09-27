//
//  Stop+CoreDataProperties.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 27/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Stop {

    @NSManaged var name: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber

}
