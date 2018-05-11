//
//  ProfileFeedTableViewCell.swift
//  RunCoin
//
//  Created by Roland Christensen on 5/11/18.
//  Copyright © 2018 Roland Christensen. All rights reserved.
//

import UIKit

class ProfileFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var runMapImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        profileImageView.clipsToBounds = true
        // Configure the view for the selected state
    }

}
