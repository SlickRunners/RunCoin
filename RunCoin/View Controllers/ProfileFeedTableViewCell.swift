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
    
    var user : User? {
        didSet{
            setUpUserInfo()
        }
    }
    
    var post : FeedPost? {
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameLabel.text = ""
        DateLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "PlaceholderDude")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView(){
        DateLabel.text = post?.date
        if let photoURLString = post?.runMap {
            let photoURL = URL(string: photoURLString)
            runMapImageView.sd_setImage(with: photoURL)
        }
        setUpUserInfo()
    }
    
    func setUpUserInfo() {
        usernameLabel.text = user?.username
        if let photoURLString = user?.profileImageUrl {
            let photoURL = URL(string: photoURLString)
            profileImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "PlaceholderDude"))
        }
    }
}
