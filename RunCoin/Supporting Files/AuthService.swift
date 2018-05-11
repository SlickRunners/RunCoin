//
//  AuthService.swift
//  RunCoin
//
//  Created by Roland Christensen on 4/20/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
   
    
    static func signInToAccount(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError("Error logging user into Firebase with existing credentials \(error!.localizedDescription)")
                return
            }
            onSuccess()
        })
    }
    
    static func signUp(email: String, username: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                return
            }
            let uid = user?.uid
            let storageRef = Storage.storage().reference(forURL: "gs://runcoin-c565b.appspot.com").child("profile_image").child(uid!)
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
//                let profileImageURL = metadata.dow
            })
        }
    }
    
    
    
    
}
