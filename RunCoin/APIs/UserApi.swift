//
//  UserApi.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/14/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

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
    
    func observeAllUsers(completion: @escaping (User) -> Void){
        REF_USERS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict)
                completion(user)
            }
        }
    }
    
    var CURRENT_USER : UserInfo? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        return nil
    }
    
    var REF_CURRENT_USER : DatabaseReference? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return REF_USERS.child(currentUser.uid)
    }
}
