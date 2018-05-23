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
}

extension FeedPost {
    static func transformPost(dict: [String : Any]) -> FeedPost {
        let post = FeedPost()
        post.pace = dict["pace"] as? String
        post.runMap = dict["mapUrl"] as? String
        post.distance = dict["distance"] as? String
        post.duration = dict["duration"] as? String
        post.date = dict["timestamp"] as? String
        return post
    }
}
