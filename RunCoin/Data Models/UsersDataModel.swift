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
}

extension User {
    static func transformUser(dict: [String : Any]) -> User{
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        return user
    }
}
