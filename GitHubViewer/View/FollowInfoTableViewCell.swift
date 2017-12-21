//
//  FollowInfoTableViewCell.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/24/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit


/// Custom TableView Cell for displaying follow/following users
class FollowInfoTableViewCell: UITableViewCell {

    /// username label
    @IBOutlet weak var followUserNameLabel: UILabel!
    
    /// profile pic image view
    @IBOutlet weak var followUserProfileImage: UIImageView!
    
    /// follow button
    @IBOutlet weak var followButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
