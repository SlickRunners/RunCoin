//
//  SearchTableViewCell.swift
//  RunCoin
//
//  Created by Roland Christensen on 6/19/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var user : User? {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "blankProfileImage"))
            profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
            profileImage.layer.borderColor = UIColor.offBlue.cgColor
            profileImage.layer.borderWidth = 2
        }
        if user!.isFollowing! == true {
            configureUnFollowButton()
        } else {
            configureFollowButton()
        }
    }
    
    @objc func followAction(){
        if user!.isFollowing! == false {
            Api.Follow.followAction(withUser: user!.id!)
            configureUnFollowButton()
            user!.isFollowing! = true
        }
    }
    
    @objc func unFollowAction(){
        if user!.isFollowing! == true {
            Api.Follow.unFollowAction(withUser: user!.id!)
            configureFollowButton()
            user!.isFollowing! = false
        }
    }
    
    func configureFollowButton(){
        followButton.addTarget(self, action: #selector(self.followAction), for: UIControlEvents.touchUpInside)
        followButton.setTitle("Follow", for: .normal)
        followButton.layer.backgroundColor = UIColor.offBlue.cgColor
        followButton.titleLabel?.textColor = UIColor.white
        followButton.setTitleColor(UIColor.white, for: .normal)
    }
    func configureUnFollowButton(){
        followButton.addTarget(self, action: #selector(self.unFollowAction), for: UIControlEvents.touchUpInside)
        followButton.setTitle("Following", for: .normal)
        followButton.layer.borderWidth = 1.0
        followButton.layer.borderColor = UIColor.offBlue.cgColor
        followButton.setTitleColor(UIColor.offBlue, for: .normal)
        followButton.layer.backgroundColor = UIColor.white.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
