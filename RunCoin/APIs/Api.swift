//
//  Api.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/14/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation

struct Api {
    static var User = UserApi()
    static var Post = PostApi()
    static var MyPosts = MyPostsApi()
    static var Follow = FollowApi()
}
