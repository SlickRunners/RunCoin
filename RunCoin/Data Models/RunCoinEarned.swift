//
//  RunCoinEarned.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/11/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import FirebaseAuth

class EarnedRunCoin {
    
    static func runCoinedEarned(runCoin: String, distance: String) {
        var runCoin = 0
        let random = String(arc4random_uniform(8) + 2)
        if distance == random {
            runCoin += 1
            let databaseRef = Database.database().reference()
            if let currentUser = Auth.auth().currentUser {
                let uid = currentUser.uid
                let runCoinNode = databaseRef.child("ruc_coins").child(uid)
                runCoinNode.setValue(runCoin)
                print("Success You've Earned a runcoin MOTHAFUCKA!!!!!!")
            }
        }
    }
}
