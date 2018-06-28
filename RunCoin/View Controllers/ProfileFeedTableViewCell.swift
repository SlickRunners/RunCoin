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
        if let photoURLString = post?.runMap {
            let photoURL = URL(string: photoURLString)
            runMapImageView.sd_setImage(with: photoURL)
        }
        DateLabel.text = post?.date
        
        if let timestamp = post?.timestamp {
            let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            
            var timeText = ""
            if diff.second! <= 0 {
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute! == 0 {
                timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
            }
            if diff.minute! > 0 && diff.hour! == 0 {
                timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
            }
            if diff.hour! > 0 && diff.day! == 0 {
                timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
            }
            if diff.day! > 0 && diff.weekOfMonth! == 0 {
                timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
            }
            if diff.weekOfMonth! > 0 {
                timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
            }
            DateLabel.text = timeText
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
