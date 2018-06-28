//
//  RunDataModel.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/9/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation

class FeedPost {
    var distance : String?
    var duration : String?
    var date : String?
    var pace : String?
    var runMap : String?
    var uid : String?
    var key : String?
    var id : String?
    var timestamp : Int?
}

extension FeedPost {
    static func transformPost(dict: [String : Any], key: String) -> FeedPost {
        let post = FeedPost()
        post.pace = dict["pace"] as? String
        post.runMap = dict["mapUrl"] as? String
        post.distance = dict["distance"] as? String
        post.duration = dict["duration"] as? String
        post.date = dict["date"] as? String
        post.uid = dict["uid"] as? String
        post.timestamp = dict["timestamp"] as? Int
        post.id = key
        return post
    }
}
