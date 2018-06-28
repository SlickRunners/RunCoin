//
//  File.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/20/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import FirebaseDatabase
//Following and unfollowing is with respect to the current user.

class FollowApi {
    var REF_FOLLOWERS = Database.database().reference().child("followers")
    var REF_FOLLOWING = Database.database().reference().child("following")
    
    func followAction(withUser id: String){
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                for key in dict.keys {
                    if let value = dict[key] as? [String : Any]{
                        let timestampdate = value["timestamp"] as! Int
                        Api.Feed.REF_FEED.child(Api.User.CURRENT_USER!.uid).child(key).setValue(["timestamp": timestampdate])
                    }
                }
            }
        }
        REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(true)
        REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(true)
    }
    
    func unFollowAction(withUser id: String){
        Api.MyPosts.REF_MYPOSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                for key in dict.keys {
                    Database.database().reference().child("feed").child(Api.User.CURRENT_USER!.uid).child(key).removeValue()
                }
            }
        }
        Api.Follow.REF_FOLLOWERS.child(id).child(Api.User.CURRENT_USER!.uid).setValue(NSNull())
        Api.Follow.REF_FOLLOWING.child(Api.User.CURRENT_USER!.uid).child(id).setValue(NSNull())
    }
    
    func isFollowing(userId: String, completed: @escaping (Bool) -> Void){
        REF_FOLLOWERS.child(userId).child(Api.User.CURRENT_USER!.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                completed(false)
            } else {
                completed(true)
            }
        }
    }
    
}
