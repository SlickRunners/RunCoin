//
//  File.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/20/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

class HelperService {
    //globalRunCoin: Int, globalDistance: Double, globalDuration: Int16
    static func uploadDataToStorage(image: UIImage, distance: String, duration: String, date: String, pace: String, singleRunCoin: Int, globalRunCoin: Int, globalDistance: Double, globalDuration: Int){
        if let imageData = UIImagePNGRepresentation(image) {
            let mapDataID = NSUUID().uuidString
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("run_posts").child(mapDataID)
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL { (url, error) in
                    guard let downloadUrl = url else {return}
                    let mapUrl = downloadUrl.absoluteString
                    
                    sendDataToDatabase(distance: distance, duration: duration, date: date, pace: pace, mapUrl: mapUrl, singleRunCoin: singleRunCoin)
                    updateGlobalStats(globalRunCoin: globalRunCoin, globalDistance: globalDistance, globalDuration: globalDuration)
                }
            }
        }
    }
    
    static func sendDataToDatabase(distance: String, duration: String, date: String, pace: String, mapUrl: String, singleRunCoin: Int){
        guard let currentUser = Api.User.CURRENT_USER else {
            print("No current firebase user")
            return
        }
        let uid = currentUser.uid
        let newPostId = Api.Post.REF_POSTS.childByAutoId().key
        let newPostRef = Api.Post.REF_POSTS.child(newPostId)
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        let runDict = ["uid": uid, "distance": distance, "duration": duration, "date": date, "pace": pace, "mapUrl": mapUrl, "timestamp": timestamp, "runCoin": singleRunCoin] as [String : Any]
        
        newPostRef.setValue(runDict, withCompletionBlock: {
            error, ref in
            if error != nil {
                print("Error saving map image to firebase!")
                return
            }
            
            Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(newPostId).setValue(["timestamp": timestamp])
            
            let myPostRef = Api.MyPosts.REF_MYPOSTS.child(uid).child(newPostId)
            myPostRef.setValue(["timestamp": timestamp], withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }
            })
        })
    }
    
    static func updateGlobalStats(globalRunCoin: Int, globalDistance: Double, globalDuration: Int){
        
        let globalDict = ["globalRunCoin": globalRunCoin, "globalDistance": globalDistance, "globalDuration": globalDuration] as [String : Any]
        
        Api.User.REF_CURRENT_USER?.updateChildValues(globalDict)
    }
    
    static func updateUserRunCoinCount(globalRunCoin : Int, singleRunCoin : Int){
        let globalRunCoinRef = ["globalRunCoin" : globalRunCoin]
        let singleRunCoinRef = ["singleRunCoin" : singleRunCoin]
        let postId = Api.Post.REF_POSTS.childByAutoId().key
        let postRef = Api.Post.REF_POSTS.child(postId).child("runCoin")
        postRef.setValue(singleRunCoinRef)
        
        Api.User.REF_CURRENT_USER?.updateChildValues(globalRunCoinRef)
    }
    
}


