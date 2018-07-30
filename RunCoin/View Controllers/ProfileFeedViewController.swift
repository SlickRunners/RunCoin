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
    @IBOutlet weak var globalDistanceLabel: UILabel!
    @IBOutlet weak var globaleDurationLabel: UILabel!
    @IBOutlet weak var globalRunCoinLabel: UILabel!
    @IBAction func unwindToVC1(segue:UIStoryboardSegue){}
    
    var posts = [FeedPost]()
    var users = [User]()
    var myPosts : [FeedPost]!
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFeedData()
        setUpView()
        tableView.estimatedRowHeight = 418
        tableView.rowHeight = UITableViewAutomaticDimension
        configureGlobalStats()
    }
        
    func loadFeedData(){
        isLoading = true
        Api.Feed.getRecentFeed(withId: Api.User.CURRENT_USER!.uid, start: posts.first?.timestamp, limit: 5) { (results) in
            if results.count > 0 {
                results.forEach({ (result) in
                    self.posts.append(result.0)
                    self.users.append(result.1)
                })
            }
            self.isLoading = false
            self.tableView.reloadData()
        }
        
        Api.Feed.observeFeedRemoved(withId: Api.User.CURRENT_USER!.uid) { (post) in
            //code below filters out posts not matching post.uid and key
            self.posts = self.posts.filter { $0.id != post.id }
            self.users = self.users.filter { $0.id != post.uid }
            self.tableView.reloadData()
        }
    }
    
    func loadMorePosts(){
        guard !isLoading else {
            return
        }
        isLoading = true
        guard let latestPostTimestamp = self.posts.last?.timestamp else {
            isLoading = false
            return
        }
        Api.Feed.getOlderFeed(withId: Api.User.CURRENT_USER!.uid, start: latestPostTimestamp, limit: 5) { (results) in
            if results.count == 0 {
                return
            }
            for result in results {
                self.posts.append(result.0)
                self.users.append(result.1)
            }
            self.isLoading = false
            self.tableView.reloadData()
        }
    }
    
    func setUpView(){
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowRadius = 5.0
        headerView.layer.shadowOpacity = 0.25
        headerView.layer.backgroundColor = UIColor.white.cgColor
        
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = "Activity"
        
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowRadius = 5.0
        tableView.layer.shadowOpacity = 0.25
        tableView.layer.backgroundColor = UIColor.white.cgColor
        
        //gradient border for globalruncoinlabel
        globalRunCoinLabel.layer.borderColor = UIColor.offBlue.cgColor
        globalRunCoinLabel.layer.cornerRadius = globalRunCoinLabel.frame.size.height/2
        globalRunCoinLabel.layer.borderWidth = 3
    }
    
    func configureGlobalStats(){
        Api.User.oberserveCurrentUser { (user) in
            let formattedRunCoin = user.globalRunCoin?.description
            self.globalRunCoinLabel.text = formattedRunCoin
            
            let formattedDistance = FormatDisplay.distance(user.globalDistance!)
            self.globalDistanceLabel.text = formattedDistance
            
            let formattedDuration = FormatDisplay.time(user.globaleDuration!)
            self.globaleDurationLabel.text = formattedDuration
        }
    }
}

extension ProfileFeedViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + self.view.frame.size.height >= scrollView.contentSize.height {
            loadMorePosts()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUserSettings" {
            let accountVC = segue.destination as! AccountViewController
            accountVC.delegate = self
        }
    }
}

extension ProfileFeedViewController : AccountViewControllerDelegate {
    func updateUserInformation() {
        print("protocol called successfully")
    }
}
