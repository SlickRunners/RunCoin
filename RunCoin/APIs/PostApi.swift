//
//  PostApi.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/14/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostApi {
    var REF_POSTS = Database.database().reference().child("run_data")
    
    func observePosts(completion: @escaping (FeedPost) -> Void){
        REF_POSTS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let newPost = FeedPost.transformPost(dict: dict, key: snapshot.key)
                completion(newPost)
            }
        }
    }
    
    func observePost(withId id: String, completion: @escaping(FeedPost) -> Void) {
        REF_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let post = FeedPost.transformPost(dict: dict, key: snapshot.key)
                completion(post)
            }
        }
    }
}
