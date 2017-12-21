//
//  GitHubCommunicator.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/17/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import UIKit

/// A struc that fetches and returns data from GitHub profile
struct GitHubCommunicator {
    
    
    /// The base url for all GitHub API requests
    let baseUrl = "https://api.github.com/"
    
    
    /**
     Fetches the users profile info. Has a completionHandler that is called
     when the image is downloaded.
     
     - Parameter userName: users 'login'
     */
    func fetchProfileDataFor(user username: String,_ completionHandler: @escaping (_ profileData: GitHubProfile?,_ error: Error?) -> ()) {
        
        // form url request to fetch profile
        let urlString = baseUrl + "users/" + username
        
        // fetch data from the network
        Networking().requestFor(url: urlString, withBody: nil, andHeaders: nil, ofType: "GET") { (profileData, err) in
            
            // if we received data from the request
            if profileData != nil {
                
                // convert the data to JSON, then convert the JSON to 'GitHubProfile'
                let profileJson = DataToJSON().dataToJson(data: profileData!)
                if let profile = GitHubProfile(json: profileJson!) {
                    
                    // call completion handler with the GitHubProfile
                    completionHandler(profile, nil)
                }
            } else {
                completionHandler(nil, nil)
            }
            
        }
        
    }
    
    
    /**
     Fetches the users profile image givin their avatar url. Has a completionHandler that is
     called when the image is downloaded.
     
     - Parameter imageUrl: string of users 'avatar_url'
     */
    func fetchProfileImageFrom(url imageUrl: String,_ completionHandler: @escaping (_ profileImageData: Data?) -> ()) {
        
        // fetch data from the network
        Networking().sessionFor(url: imageUrl) { (imageData) in
            
            // call completion handler with image Data
            completionHandler(imageData)
        }
        
    }
    
    
    /**
     Fetches the public repositories for a given user
     
     - Parameter username: the function uses this username to fetch the functions
     */
    func fetchRepositoriesFor(user username: String,_ completionHandler: @escaping (_ repositories: [GitHubRepository]?, _ error: Error?) -> () ) {
        
        // form the url for the repositories request, and set the query/sort parameters
        let urlString = baseUrl + "users/" + username + "/repos"
        let parameters = [("type","all"), ("sort","updated"), ("direction","desc")]
        print(urlString)
        // fetch the data from the netfork
        Networking().requestFor(url: urlString, withBody: parameters, andHeaders: nil, ofType: "GET") { (repoData, error) in
            
            // if we received data
            if repoData != nil && error == nil {
                // convert the data to an array of JSON, then convert into array of 'GitHubRepository'
                let jsonRepoData = DataToJSON().dataToArrayOfJson(data: repoData!)
                
                var repos = [GitHubRepository]()
                for jsonRepo in jsonRepoData! {
                    if let repo = GitHubRepository(json: jsonRepo) {
                        repos.append(repo)
                    }
                }
                
                // call completion handler with repo data
                completionHandler(repos, nil)
                
            } else {
                completionHandler(nil, nil)
            }
        }
        
    }
    
    
    /**
     Fetches the users follow informated and completes with a list us GitHubProdiles which are either the users followers
     or the users the user followes.
     
     - Parameters:
     - userName: users 'login'
     - type: either 'following' or 'followers'
     */
    func fetchFollowInformationFor(user username: String, followOrFollowing type: String,_ completionHandler: @escaping (_ followUsers: [GitHubProfile]?, _ error: Error?) -> () ) {
        
        // for url for Follower/following request
        let urlString = baseUrl + "users/" + username + "/" + type
        
        // fetch data from the network
        Networking().requestFor(url: urlString, withBody: nil, andHeaders: nil, ofType: "GET") { (followData, error) in
            
            // if we received data
            if followData != nil {
                
                // convert the data to an array of JSON
                let jsonProfileData = DataToJSON().dataToArrayOfJson(data: followData!)
                
                // return val
                var users = [GitHubProfile]()
                
                // create group for multiple net requests
                let myGroup = DispatchGroup()
                
                for jsonProfile in jsonProfileData! {
                    
                    guard let username = jsonProfile["login"] as! String? else { return }
                    
                    myGroup.enter()
                    
                    GitHubCommunicator().fetchProfileDataFor(user: username, { (profile, error) in
                        if profile != nil {
                            users.append(profile!)
                            myGroup.leave()
                        }
                    })
                    
                }
                
                myGroup.notify(queue: .main) {
                    completionHandler(users, nil)
                }
                
            } else {
                completionHandler(nil, nil)

            }
            
        }
    }
    
    
    /**
     Follows a user
     
     - Parameters:
     - user: the users username
     - completionHandler: says if the request was successful or not
     */
    func follow(user: String,_ completionHandler: @escaping (_ success: Bool) -> ()) {
        
        let url = baseUrl + "user/" + "following/" + user
        let loginString = basicAuthentication(username: (Profile.shared.username)!, password: Profile.shared.pass!)
        let kv = [("Authorization", "Basic \(loginString)")]
        
        Networking().requestFor(url: url, withBody: nil, andHeaders: kv, ofType: "PUT") { (returnData, error) in
            completionHandler(returnData != nil)
        }
        
    }
    
    /**
     Unfollows a user
     
     - Parameters:
     - user: the users username
     - completionHandler: says if the request was successful or not
     */
    func unfollow(user: String,_ completionHandler: @escaping (_ success: Bool) -> ()) {
        
        let url = baseUrl + "user/" + "following/" + user
        let loginString = basicAuthentication(username: (Profile.shared.username)!, password: Profile.shared.pass!)
        let kv = [("Authorization", "Basic \(loginString)")]
        
        Networking().requestFor(url: url, withBody: nil, andHeaders: kv, ofType: "DELETE") { (returnData, error) in
            completionHandler(returnData != nil)
        }
    }
    
    /**
     Searches GitHub Users by username
     
     - Parameters:
     - username: the users username
     - withParameters: an array of optional search parameters
     - completionHandler: a function that takes an array as its parameter, and returns noting
     */
    func search(user username: String, withParameters params: [(key: String, value: String)]?, _ completionHandler: @escaping (_ notifications: [(login:String,avatarUrl:String)]?) -> ()) {
        if username.isEmpty {
            return
        }
        
        // form URL
        let url = baseUrl + "search/users?" + params![0].key + "=" + params![0].value + "&" + params![1].key + "=" + params![1].value + "&" + params![2].key + "=" + params![2].value
        
        // create Request
        Networking().requestFor(url: url, withBody: nil, andHeaders: nil, ofType: "GET") { (searchUserData, error) in
            
            // if we received data
            if searchUserData != nil {
                
                // convert the data to JSON
                let jsonProfileData = DataToJSON().dataToJson(data: searchUserData!)
                
                // get the valus for "items"
                let arrayJSON = jsonProfileData!["items"] as! [[String:Any]]?
                
                // return val
                var users = [(login:String,avatarUrl:String)]()
                
                // extrace info from all JSON
                for jsonProfile in arrayJSON! {
                    users.append((jsonProfile["login"] as! String, jsonProfile["avatar_url"] as! String))
                }
                
                completionHandler(users)
                
            } else {
                completionHandler(nil)
                
            }
            
        }
        
    }
    
    /**
     Searches GitHub Repos by repo name
     
     - Parameters:
     - repoName: the repos name
     - withParameters: an array of optional search parameters
     - completionHandler: a function that takes an array as its parameter, and returns noting
     */
    func search(repository repoName: String, withParameters params: [(key: String, value: String)]?, _ completionHandler: @escaping (_ notifications: [(name:String, owner: String, description:String)]?) -> ()) {
        if repoName.isEmpty {
            return
        }
        // form URL
        let url = baseUrl + "search/repositories?" + params![0].key + "=" + params![0].value + "&" + params![1].key + "=" + params![1].value + "&" + params![2].key + "=" + params![2].value
        
        // create network request
        Networking().requestFor(url: url, withBody: nil, andHeaders: nil, ofType: "GET") { (searchUserData, error) in
            
            // if we received data
            if searchUserData != nil {
                
                // convert the data to JSON
                let jsonProfileData = DataToJSON().dataToJson(data: searchUserData!)
                let arrayJSON = jsonProfileData!["items"] as! [[String:Any]]?
                
                // return val
                var repos = [(name:String, owner: String, description:String)]()
                
                // extract info form JSON
                for jsonProfile in arrayJSON! {
                    
                    var desc: String
                    if !(jsonProfile["description"] is NSNull) {
                        desc = jsonProfile["description"] as! String
                    } else {
                        desc = ""
                    }
                    
                    repos.append((jsonProfile["name"] as! String, (jsonProfile["owner"] as! [String:Any])["login"] as! String, desc))
                    
                }
                
                completionHandler(repos)
                
            } else {
                completionHandler(nil)
                
            }
            
        }
    }
    
    //    /**
    //     Stars a repo
    //
    //     - Parameters:
    //     - repository: the repo to star
    //     - completionHandler: says if the request was successful or not
    //     */
    //    func star(repo repository: GitHubRepository, _ completionHandler: @escaping (_ success: Bool) -> () ) {
    //
    //        let url = baseUrl + "user/starred/" + repository.owner + "/" + repository.name
    //        let loginString = basicAuthentication(username: (Profile.shared.username)!, password: Profile.shared.pass!)
    //        let kv = [("Authorization", "Basic \(loginString)")]
    //
    //        Networking().requestFor(url: url, withBody: nil, andHeaders: kv, ofType: "PUT") { (returnData, error) in
    //            completionHandler(returnData != nil)
    //        }
    //
    //    }
    //
    //    /**
    //     Un stars a repo
    //
    //     - Parameters:
    //     - repository: the repo to unstar
    //     - completionHandler: says if the request was successful or not
    //     */
    //    func unstar(repo repository: GitHubRepository, _ completionHandler: @escaping (_ success: Bool) -> () ) {
    //
    //        let url = baseUrl + "user/starred/" + repository.owner + "/" + repository.name
    //
    //        let loginString = basicAuthentication(username: (Profile.shared.username)!, password: Profile.shared.pass!)
    //        let kv = [("Authorization", "Basic \(loginString)")]
    //
    //        Networking().requestFor(url: url, withBody: nil, andHeaders: kv, ofType: "DELETE") { (returnData, error) in
    //            completionHandler(returnData != nil)
    //        }
    //    }
    //
    
    /**
     helper function for Basic Authentication
     
     - Parameters:
     - user: the users username
     - password: the users password
     */
    private func basicAuthentication(username: String, password: String) -> String {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
    
}
