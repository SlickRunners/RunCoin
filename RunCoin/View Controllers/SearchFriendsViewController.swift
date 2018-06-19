//
//  SearchFriendsViewController.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/19/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class SearchFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    func loadUsers(){
        Api.User.observeAllUsers { (user) in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension SearchFriendsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
}
