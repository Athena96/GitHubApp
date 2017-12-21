//
//  GitHubRepository.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/20/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation

/// A struct that represents the info of a public repository in a users GitHub account
struct GitHubRepository {

    
    /// The name of the repository
    var name: String
    
    /// The username of the repo owner
    var owner: String

    /// The link to the webpage of the repo
    var link: String

    /// A description of the repo
    var readMe: String?
    
    /**
     Initializes a GitHubRepo
     - Parameters:
     All of the required parameters
     */
    init(name: String, owner: String, readMe: String?, link: String) {
        self.name = name
        self.owner = owner
        self.readMe = readMe
        self.link = link
    }
    
    /**
     Initializes a new GitHubProfile instance from json fetched over the network from GitHub.
     
     - Parameters:
     - json: json in the form of a dictionary with a string as a key and Any as the value
     
     - Returns: a new GitHubProfile instance
     */
    init?(json: [String:Any]) {
        
        guard let name = json["name"] as! String! else { return nil }
        guard let owner = (json["owner"] as! [String:Any])["login"] as! String! else { return nil }
        guard let link = json["html_url"] as! String! else { return nil }
        
        // get optional Values
        var readMe: String?
        if !(json["description"] is NSNull) {
            readMe = json["description"] as! String?
        } else {
            readMe = nil
        }
        
        self.name = name
        self.owner = owner
        self.link = link
        self.readMe = readMe
    }
    
}

