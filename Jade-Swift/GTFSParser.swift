//
//  GTFSParser.swift
//  Jade-Swift
//
//  Created by Clément Roulland on 28/09/2015.
//  Copyright © 2015 Brozh. All rights reserved.
//

import UIKit
import CoreData

class GTFSParser: NSObject {

    var managedObjectContext: NSManagedObjectContext!{
        return (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    }

    private func parseCSV(url: NSURL) throws -> [[String]] {

        var stringFromFile: String

        // open file
        stringFromFile = try String(contentsOfURL: url)

        // remove double quotes
        stringFromFile = stringFromFile.stringByReplacingOccurrencesOfString("\"", withString: "")

        // init array
        var resultArray = [[String]]()

        // split file with end of line character
        let lines = stringFromFile.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())

        for line in lines {
            // split each line with coma

            let fieldsOfLine = line.componentsSeparatedByString(",")
            resultArray.append(fieldsOfLine)
        }

        return resultArray
    }

    func parseStops() throws {

        let stopsFilePath = NSBundle.mainBundle().pathForResource("stops", ofType: "txt")!
        let stopsFileUrl = NSURL(fileURLWithPath: stopsFilePath)

        var stopsData = try self.parseCSV(stopsFileUrl)
        // remove headers line
        stopsData.removeFirst()
        stopsData.removeLast()

        for stopData in stopsData {
            let name = stopData[2]
            let latitue = stopData[4]
            let longitude = stopData[5]
            let newStop = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: managedObjectContext) as! Stop
            (newStop.name, newStop.latitude, newStop.longitude) = (name, Double(latitue)!, Double(longitude)!)
        }
        try managedObjectContext.save()
    }

}
