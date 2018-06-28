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
    @IBOutlet weak var runMapImageView: UIImageView!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var runDistanceLabel: UILabel!
    @IBOutlet weak var runDurationLabel: UILabel!
    @IBOutlet weak var runAveragePaceLabel: UILabel!
    @IBOutlet weak var runCoinEarnedLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
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
        DateLabel.text = ""
        runDistanceLabel.text = ""
        runAveragePaceLabel.text = ""
        runCoinEarnedLabel.text = ""
        runDurationLabel.text = ""
        usernameLabel.text = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "PlaceholderDude")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateView(){
        runDistanceLabel.text = post?.distance
        runDurationLabel.text = post?.duration
        runAveragePaceLabel.text = post?.pace
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
            profileImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "blankProfileImage"))
        }
    }
}
