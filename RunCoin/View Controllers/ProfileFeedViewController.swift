//
//  FeedViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/9/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var aggregateDistanceLabel: UILabel!
    @IBOutlet weak var aggregateDurationLabel: UILabel!
    @IBAction func unwindToVC1(segue:UIStoryboardSegue){}
    
    var posts = [FeedPost]()
    var users = [User]()
    var myPosts : [FeedPost]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedData()
        setUpView()
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func fetchMyPosts() {
        guard let currentUser = Api.User.CURRENT_USER else {
            return
        }
        let uid = currentUser.uid
        Api.MyPosts.REF_MYPOSTS.child(uid).observe(.childAdded) { (snapshot) in
            Api.Post.observePost(withId: snapshot.key, completion: { (post) in
                self.posts.append(post)
                self.tableView.reloadData()
            })
        }
    }
    
    func loadFeedData(){
        Api.Feed.observeFeed(withId: Api.User.CURRENT_USER!.uid) { (post) in
            guard let postId = post.uid else {
                return
            }
            self.fetchUser(uid: postId, completed: {
                self.posts.append(post)
                self.tableView.reloadData()
            })
        }
        
        Api.Feed.observeFeedRemoved(withId: Api.User.CURRENT_USER!.uid) { (key) in
            //code below filters out posts not matching post.uid and key
            self.posts = self.posts.filter { $0.id != key }
            self.tableView.reloadData()
        }
    }
    
    func fetchUser(uid: String, completed: @escaping ()-> Void){
        Api.User.observeUser(withId: uid) { (user) in
            self.users.append(user)
            completed()
        }
    }
}


extension ProfileFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! ProfileFeedTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        cell.post = post
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func setUpView(){
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowRadius = 5.0
        headerView.layer.shadowOpacity = 0.25
        headerView.layer.backgroundColor = UIColor.white.cgColor
        
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        title = "Activity"
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowRadius = 5.0
        tableView.layer.shadowOpacity = 0.25
        tableView.layer.backgroundColor = UIColor.white.cgColor
    }
    
}
