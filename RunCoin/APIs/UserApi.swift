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
    var REF_GLOBAL_DISTANCE = Database.database().reference().child("users").child("globalDistance")
    
    func observeUser(withId uid: String, completion: @escaping (User) -> Void ) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func observeAllUsers(completion: @escaping (User) -> Void){
        REF_USERS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                print("SNAPSHOTKEY",snapshot.key)
                if user.id! != Api.User.CURRENT_USER?.uid {
                    completion(user)
                }
            }
        }
    }
    
    func queryUser(withText text: String, completion: @escaping (User) -> Void){
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").queryLimited(toFirst: 25).observeSingleEvent(of: .value, with: {
            snapshot in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String : Any] {
                    let user = User.transformUser(dict: dict, key: snapshot.key)
                    completion(user)
                }
            })
        })
    }
    
    var CURRENT_USER : FirebaseAuth.User? {
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
    
    func oberserveCurrentUser(completion: @escaping (User) -> Void){
        guard let currentUser = CURRENT_USER else {return}
        REF_USERS.child(currentUser.uid).observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func observeGlobalStats(completion: @escaping (User) -> Void){
        guard let currentUser = CURRENT_USER else {return}
        REF_USERS.child(currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
}
