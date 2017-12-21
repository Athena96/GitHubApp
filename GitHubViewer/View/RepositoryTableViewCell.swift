//
//  RepositoryTableViewCell.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/21/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit

/// Custom TableView Cell for displaying repositories
class RepositoryTableViewCell: UITableViewCell {

    /// The name label for the repository
    @IBOutlet weak var repoNameLabel: UILabel!
    
    /// The author label for the repository
    @IBOutlet weak var authorLabel: UILabel!
    
    /// The description lavel for the repository
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
