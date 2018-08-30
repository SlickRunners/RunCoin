//
//  UsersDataModel.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/23/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation

class User {
    var email : String?
    var profileImageUrl : String?
    var username : String?
    var id : String?
    var isFollowing : Bool?
    var globalRunCoin : Int?
    var globalDistance : Double?
    var globaleDuration: Int?
}

extension User {
    static func transformUser(dict: [String : Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.globalDistance = dict["globalDistance"] as? Double
        user.globalRunCoin = dict["globalRunCoin"] as? Int
        user.globaleDuration = dict["globalDuration"] as? Int
        user.id = key
        return user
    }
}
