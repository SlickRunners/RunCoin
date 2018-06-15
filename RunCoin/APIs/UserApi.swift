//
//  UserApi.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/14/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserApi {
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void ) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                completion(user)
            }
        }
    }
}
