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
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        loadFeedData()
        title = "User Profile"
    }
    
    
    func loadFeedData(){
        Database.database().reference().child("run_data").observe(.childAdded) { (snapshot) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! ProfileFeedTableViewCell
        let post = posts[indexPath.row]
        cell.DateLabel.text = post.date
        if let photoURLString = post.runMap {
            let photoURL = URL(string: photoURLString)
            cell.runMapImageView.sd_setImage(with: photoURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
}
