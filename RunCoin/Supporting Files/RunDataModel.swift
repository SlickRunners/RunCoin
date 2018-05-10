//
//  RunDataModel.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/9/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation

class RunDataModel {
    
    var distance = Double()
    var duration = Double()
    var pace = Double()
    var date = Date()
    
    init(distance: Double, duration: Double, pace: Double, date: Date){
        self.distance = distance
        self.duration = duration
        self.pace = pace
        self.date = date
    }
    
}
