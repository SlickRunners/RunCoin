//
//  Location+CoreDataProperties.swift
//  RunCoin
//
//  Created by Roland Christensen on 7/9/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Date
    @NSManaged public var run: Run

}
