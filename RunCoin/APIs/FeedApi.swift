//
//  FeedApi.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/22/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FeedApi {
    var REF_FEED = Database.database().reference().child("feed")
    
    func observeFeed(withId Id: String, completion: @escaping (FeedPost) -> Void){
        REF_FEED.child(Id).queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        }
    }
    
    func observeFeedRemoved(withId Id: String, completion: @escaping (FeedPost) -> Void){
        REF_FEED.child(Id).observe(.childRemoved) { (snapshot) in
            let key = snapshot.key
            Api.Post.observePost(withId: key, completion: { (post) in
                completion(post)
            })
        }
    }
}
