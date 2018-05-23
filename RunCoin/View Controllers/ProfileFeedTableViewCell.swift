//
//  ProfileFeedTableViewCell.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/11/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit
import Firebase

class ProfileFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var runMapImageView: UIImageView!
    
    @IBOutlet weak var DateLabel: UILabel!
    
    var post : FeedPost? {
        didSet{
            updateView()
        }
    }
    
    func updateView(){
        
    }
    
    func setUpUserInfo() {
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
