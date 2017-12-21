//
//  GitHubProfile.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/20/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import UIKit

/// A struct that represents the data from a GitHub user profile
struct GitHubProfile {
    
    /// users name
    public var name: String
    
    /// users login
    public var username: String
    
    /// The url that the users avatar image can be downloaded at
    public var avatarUrl: String
    
    /// number of publics repos
    public var publicReposCount: Int
    
    /// The number of followers the user has
    public var followersCount: Int
    
    /// The number of other users the user is following
    public var followingCount: Int
    
    /// The date the users profile was created
    public var profileCreateDate: String
    
    /// The users bio if they have one
    public var bio: String?
    
    /// The users website link if they have one
    public var website: String?
    
    
    /**
     initializer for the class
     - Parameters:
     - all parameters for the class
     */
    init(
        name: String,
        username: String,
        avatarUrl: String,
        publicReposCount: Int,
        followersCount: Int,
        followingCount: Int,
        profileCreateDate: String,
        bio: String?,
        website: String?) {
        
        self.name = name
        self.username = username
        self.avatarUrl = avatarUrl
        self.publicReposCount = publicReposCount
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.profileCreateDate = profileCreateDate
        self.bio = bio
        self.website = website
        
    }
    
    /**
     Initializes a new GitHubProfile instance from json fetched over the network from GitHub.
     
     - Parameters:
     - json: json in the form of a dictionary with a string as a key and Any as the value
     
     - Returns: a new GitHubProfile instance
     */
    init?(json: [String:Any]) {
        
        // get required values, fail otherwise
        guard let username = json["login"] as! String? else { return nil }
        guard let avatarUrl = json["avatar_url"] as! String? else { return nil }
        guard let publicReposCount = json["public_repos"] as! Int? else { return nil }
        guard let followersCount = json["followers"] as! Int? else { return nil }
        guard let followingCount = json["following"] as! Int? else { return nil }
        guard let profileCreateDate = json["created_at"] as! String? else { return nil }
        
        // get optional Values
        var bio: String?
        if !(json["bio"] is NSNull) {
            bio = json["bio"] as! String?
        } else {
            bio = nil
        }
        
        var website: String?
        if !(json["blog"] is NSNull) {
            website = json["blog"] as! String?
        } else {
            website = nil
        }
        
        var name: String
        if !(json["name"] is NSNull) {
            name = (json["name"] as! String?)!
        } else {
            name = "-"
        }
 
        // assign values
        self.name = name
        self.username = username
        self.avatarUrl = avatarUrl
        self.publicReposCount = publicReposCount
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.profileCreateDate = profileCreateDate
        self.bio = bio
        self.website = website
        
    }
    
    // fetched the users profile pic
    func getProfilePic(_ completionHandler: @escaping (_ image: UIImage?) -> () ) {
        
        GitHubCommunicator().fetchProfileImageFrom(url: self.avatarUrl) { (fetchedImageData) in
            DispatchQueue.main.async {
                // unwrap the data
                if let imageData = fetchedImageData {
                   
                    // convert data to UIImage and call the completion handler if successful
                    if let image = UIImage(data: imageData) {
                        completionHandler(image)
                    }
                }
                completionHandler(nil)
            }
        }
        
    }
    
}

