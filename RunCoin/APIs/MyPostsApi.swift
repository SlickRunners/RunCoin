//
//  MyPostsApi.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/18/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class MyPostsApi {
    var REF_MYPOSTS = Database.database().reference().child("my_posts")
    
}
