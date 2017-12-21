//
//  ProfileViewController.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/17/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit
import SafariServices

/// VC Class responsible for displaying the users profile info
class ProfileViewController: UIViewController, SFSafariViewControllerDelegate {
    
    /// image view for profile image
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// label to hold the date the profile was created
    @IBOutlet weak var profileCreationDateLabel: UILabel!
    
    /// label for username
    @IBOutlet weak var usernameLabel: UILabel!
    
    /// label for user's bio
    @IBOutlet weak var bioLabel: UILabel!
    
    /// buttons to for the users website, public repos, and follower information
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var publicProfilesButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    /// property to hold the users profile
    var profile: GitHubProfile?
    
    
    /**
     Called once when view first loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /**
     Called everytime the view appears on screen
     
     - Parameter animated: animated or not
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        // if the vc was NOT passed a profile to display, fetch from internet
        if profile == nil {
            self.fetchData(forUser: (Profile.shared.username)!)
        }
        // display the passed VC, and try to fetch its profil pic
        else {
            
            self.updateUI()
            
            self.profile?.getProfilePic({ (profilePic) in
                DispatchQueue.main.async {
                    if profilePic != nil {
                        self.profileImageView.image = profilePic
                    } else {
                        self.profileImageView.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                    }
                }
            })
            
        }
        
    }
    
    
    /**
     Called when the view is finished laying out its subviews.
     Is used to make the image view round.
     
     */
    override func viewDidLayoutSubviews() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.layer.masksToBounds = true
    }
    
    
    /**
     Fetches the data and, onece the data is downloaded, updates the UI
     */
    func fetchData(forUser username: String) {
        
        // if the user is signed in, fetch profile data
        GitHubCommunicator().fetchProfileDataFor(user: username) { (fetchedProfile, error) in
            
            // get the main queue
            DispatchQueue.main.async {
                
                if fetchedProfile != nil {
                    self.profile = fetchedProfile!
                    
                    self.updateUI()
                    
                    self.profile?.getProfilePic({ (profilePic) in
                        DispatchQueue.main.async {
                            if profilePic != nil {
                                self.profileImageView.image = profilePic
                            } else {
                                self.profileImageView.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
                            }
                        }
                    })
                    
                    
                }
            } // end main queue
            
        } // end network fetch
        
        
    } // end func
    
    
    /**
     Is called when the user taps the website button
     
     - Parameter sender: the button itself
     */
    @IBAction func websiteButton(_ sender: UIButton) {
        
        let urlString = (sender.titleLabel?.text)!
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
        
    }
    
    /**
     Is called in the SF View Controller when the user presses the 'Done' button
     
     - Parameter controller: the SF ViewController
     */
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    /**
     Is called when the user taps the repos or follow counts buttons
     
     - Parameter sender: the button itself
     */
    @IBAction func repoFollowButtons(_ sender: UIButton) {
        if sender.titleLabel?.text?.lowercased().range(of:"repos") != nil {
            tabBarController?.selectedIndex = 0
        } else if sender.titleLabel?.text?.lowercased().range(of:"following") != nil {
            tabBarController?.selectedIndex = 1
        } else if sender.titleLabel?.text?.lowercased().range(of:"followers") != nil {
            tabBarController?.selectedIndex = 1
        }
    }
    
    
    /**
     Is called after the class gets new info to display
     */
    func updateUI() {
        if let profileInfo = profile {
            setUIElements(
                name: profileInfo.name,
                username: profileInfo.username,
                bio: (profileInfo.bio == nil) ? "No Bio" : profileInfo.bio!,
                website: (profileInfo.website == nil) ? "No Website" : profileInfo.website!,
                publicProfiles: String(profileInfo.publicReposCount) + " public repos",
                followers: "followers "+String(profileInfo.followersCount),
                following: "following "+String(profileInfo.followingCount),
                profileCreateDate: (profileInfo.profileCreateDate).toDate())
        } else {
            setUIElements(
                name: "...",
                username: "-",
                bio: "-",
                website: "-",
                publicProfiles: "-",
                followers: "-",
                following: "-",
                profileCreateDate: "-/-/-")
        }
    }

    
    /**
     Sets all the UI Elements with their respective content
     */
    func setUIElements(
        name: String,
        username: String,
        bio: String,
        website: String,
        publicProfiles: String,
        followers:String,
        following: String,
        profileCreateDate: String) {
        self.title = name
        self.usernameLabel.text = username
        self.bioLabel.text = bio
        self.websiteButton.setTitle(website, for: .normal)
        self.publicProfilesButton.setTitle(publicProfiles, for: .normal)
        self.followersButton.setTitle(followers, for: .normal)
        self.followingButton.setTitle(following, for: .normal)
        self.profileCreationDateLabel.text = profileCreateDate
    }
    
}



/// Extension to the String class, for displaying dates
extension String {
    
    /**
     Converts a string date in format: 'ISO8601DateFormatter', to a more
     human readable format
     */
    func toDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:self)!
        let y = String(Calendar.current.component(Calendar.Component.year, from: date))
        let m = String(Calendar.current.component(Calendar.Component.month, from: date))
        let d = String(Calendar.current.component(Calendar.Component.day, from: date))
        
        return (m + "/" + d + "/" + y)
    }
}
