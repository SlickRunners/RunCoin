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
    
//    func observeFeed(withId Id: String, completion: @escaping (FeedPost) -> Void){
//        REF_FEED.child(Id).queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
//            let key = snapshot.key
//            Api.Post.observePost(withId: key, completion: { (post) in
//                completion(post)
//            })
//        }
//    }
    
    func getRecentFeed(withId Id: String, start timestamp: Int? = nil, limit: UInt, completion: @escaping ([(FeedPost, User)]) -> Void){
        var feedQuery = REF_FEED.child(Id).queryOrdered(byChild: "timestamp")
        if let latestPostTimestamp = timestamp, latestPostTimestamp > 0 {
            feedQuery = feedQuery.queryStarting(atValue: latestPostTimestamp + 1, childKey: "timestamp").queryLimited(toLast: limit)
        } else {
            feedQuery = feedQuery.queryLimited(toLast: limit)
        }
        
        var results : [(post: FeedPost, user: User)] = []
        feedQuery.observeSingleEvent(of: .value) { (snapshot) in
            let items = snapshot.children.allObjects as! [DataSnapshot]
            let myGroup = DispatchGroup()
            for (index, item) in items.enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    Api.User.observeUser(withId: post.uid!, completion: { (user) in
                        if post.uid! == user.id {
                            results.append((post, user))
//                            results.insert((post, user), at: index)
                        }
                        print(index)
                        myGroup.leave()
                    })
                })
            }
            myGroup.notify(queue: DispatchQueue.main, execute: {
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp!})
                completion(results)
            })
        }
    }
    
    
    func getOlderFeed(withId Id: String, start timestamp: Int, limit: UInt, completion: @escaping ([(FeedPost, User)]) -> Void){
        let feedOrderQuery = REF_FEED.child(Id).queryOrdered(byChild: "timestamp")
        let feedLimitedQuery = feedOrderQuery.queryEnding(atValue: timestamp - 1, childKey: "timestamp").queryLimited(toLast: limit)
        
        feedLimitedQuery.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            let items = snapshot.children.allObjects as! [DataSnapshot]
            let myGroup = DispatchGroup()
            var results : [(post: FeedPost, user: User)] = []
            for (index, item) in items.enumerated() {
                myGroup.enter()
                Api.Post.observePost(withId: item.key, completion: { (post) in
                    Api.User.observeUser(withId: post.uid!, completion: { (user) in
                        results.insert((post, user), at: index)
                        myGroup.leave()
                    })
                })
            }
            myGroup.notify(queue: DispatchQueue.main, execute: {
                results.sort(by: {$0.0.timestamp! > $1.0.timestamp!})
                completion(results)
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
