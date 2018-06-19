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
    
    var user : User? {
        didSet {
            updateView()
        }
    }
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
    }
    
    func updateView(){
        nameLabel.text = user?.username
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImage.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "blankProfileImage"))
        }
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
