//
//  AuthService.swift
//  RunCoin
//
//  Created by Roland Christensen on 4/20/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

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
            guard let user = user else {return}
            let uid = user.user.uid
            let storageRef = Storage.storage().reference(forURL: "gs://runcoin-c565b.appspot.com").child("profile_image").child(uid)
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("error with signin url dL method", error!.localizedDescription)
                        return
                    }
                    guard let downloadUrl = url else {return}
                    let profileUrl = downloadUrl.absoluteString
                    self.setUserInformation(email: email, username: username, birthday: birthday, gender: gender, profileImageUrl: profileUrl, uid: uid, onSuccess: onSuccess)
                }
            }
        })
    }
    
    static func setUserInformation(email: String, username: String, birthday: String, gender: String, profileImageUrl: String, uid: String, onSuccess: @escaping () -> Void){
        let ref = Database.database().reference()
        let userRef = ref.child("users")
        let newUserRef = userRef.child(uid)
        newUserRef.setValue(["email": email, "username": username, "birthday": birthday, "gender": gender, "profileImageUrl": profileImageUrl])
        onSuccess()
    }
    
    static func sendDataToDatabase(uid: String, distance: String, duration: String, date: String, pace: String, mapUrl: String) {
        let databaseRef = Database.database().reference()
        //        let databaseRef = DatabaseReference()
        let postRef = databaseRef.child("all_friends_feed_posts")
        let postRef2 = databaseRef.child("single_user_feed_posts")
        let singleUserRef = postRef2.child(uid)
        let postId = postRef.childByAutoId().key
        let multipleUsersRef = postRef.child(postId)
        let runDict = ["uid": uid, "distance": distance, "duration": duration, "date": date, "pace": pace, "mapUrl": mapUrl]
        
        singleUserRef.setValue(runDict) { (error, ref) in
            if error != nil {
                print("error handling database call for sendDataToDatabase method in authservice.")
                return
            }
        }
        
        multipleUsersRef.setValue(runDict, withCompletionBlock: {
            error, ref in
            if error != nil {
                print("Error saving map image to firebase!")
                return
            }
        })
    }
}
