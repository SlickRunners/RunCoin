//
//  FeedViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/9/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileFeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let uid = Auth.auth().currentUser?.uid
    var posts = [FeedPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 550
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadFeedData()
        title = "User Profile"
        //var post = FeedPost(distance: 12.1, duration: 12.1, date: 1525986914.83655)
    }
    
    
    func loadFeedData(){
        Database.database().reference().child("run_data").child(uid!).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let newPost = FeedPost.transformPost(dict: dict)
                self.posts.append(newPost)
                print(self.posts)
                print(dict)
                self.tableView.reloadData()
            }
        }
    }
}


extension ProfileFeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! ProfileFeedTableViewCell
       //convertetDistance = cell.usernameLabel.text
//        let photoURLString =
        
//        cell.profileImageView.sd_setAnimationImages(with: [URL])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
}