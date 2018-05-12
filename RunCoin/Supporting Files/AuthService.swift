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
    
    static func signUp(email: String, username: String, password: String, imageData: Data, birthday: String, gender: String,  onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                onError("Error registering/singing in new user into Firebase! \(error!.localizedDescription)")
                return
            }
            let uid = user?.uid
            let storageRef = Storage.storage().reference(forURL: "gs://runcoin-c565b.appspot.com").child("profile_image").child(uid!)
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
             let profileImageUrl = metadata?.downloadURL()?.absoluteString
                
                self.setUserInformation(email: email, username: username, birthday: birthday, gender: gender, profileImageUrl: profileImageUrl!, uid: uid!, onSuccess: onSuccess)
            })
        })
    }
    
    static func setUserInformation(email: String, username: String, birthday: String, gender: String, profileImageUrl: String, uid: String, onSuccess: @escaping () -> Void){
        let ref = Database.database().reference()
        let userRef = ref.child("users")
        let newUserRef = userRef.child(uid)
        newUserRef.setValue(["email": email, "username": username, "birthday": birthday, "gender": gender, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
}
