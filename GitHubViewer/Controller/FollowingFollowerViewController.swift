//
//  FollowingFollowerViewController.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 12/20/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit

/// VC class responsible for fetch/displaying the users following/follower info
class FollowingFollowerViewController: UIViewController {

    /// Segmented control responsible to selecting between following/follower
    @IBOutlet weak var followingFollowerSegmentedControl: UISegmentedControl!
    
    /// Table View to display follower/following
    @IBOutlet weak var tableView: UITableView!
    
    /// datasource for tableview
    var profiles = [GitHubProfile]()
    
    /// a list of users that the apps user follows (used to tell follow/unfollow)
    var usersIFollow = [GitHubProfile]()
    
    /// tells of user selected following or followers and returns that string
    var source: String {
        get {
            return (followingFollowerSegmentedControl.selectedSegmentIndex == 0) ? "following" : "followers"
        }
    }
    
    /// a dictionary that maps each follow/unfollow button to a github profile
    var buttonMap = [UIButton:GitHubProfile]()
    
    
    /**
     Called once when view first loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /**
     Called everytime the view appears
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // check if the user is logged in
        guard let username = Profile.shared.username else {
            alert(message: "Need to sign in.", title: "Not Signed In", viewController: self)
            return
        }
        
        loadProfiles(forUser: username, fromSource: source)
    }
    
    
    /**
     Called once when view first loads
     
     - Parameters:
     - source: the source to load the profiles from, wither followers or following
     */
    func loadProfiles(forUser username: String,fromSource source: String) {
        
        GitHubCommunicator().fetchFollowInformationFor(user: username, followOrFollowing: source, { (fetchedProfiles, error) in
            
            DispatchQueue.main.async {
                if error != nil && fetchedProfiles == nil {
                    // UI ALERT
                    // return
                } else {
                    self.profiles.removeAll()
                    self.profiles = fetchedProfiles!
                }
                
                GitHubCommunicator().fetchFollowInformationFor(user: username, followOrFollowing: "following", { (fetchedProfiles, error) in
                    
                    DispatchQueue.main.async {
                        if error != nil && fetchedProfiles == nil {
                            // UI ALERT
                            // return
                        } else {
                            self.usersIFollow.removeAll()
                            self.usersIFollow = fetchedProfiles!
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        })
    }

    
    /**
     Called when the user changes between following/followers. The function
     re-loads the following/followers data.
     
     - Parameters:
     - sender: the UISegmentedControl
     */
    @IBAction func followingFollowerChoiceChanged(_ sender: UISegmentedControl) {

        // check if the user is logged in
        guard let username = Profile.shared.username else {
            alert(message: "Need to sign in.", title: "Not Signed In", viewController: self)
            return
        }
        
        loadProfiles(forUser: username, fromSource: source)
    }

    
    /**
     Called when the user taps the follow/unfollow button
     
     - Parameters:
     - sender: the UIButton
     */
    @IBAction func followUnfollowButton(_ sender: UIButton) {
        
        // get the user the button is associated with
        guard let user = buttonMap[sender] else {
            return
        }
        
        /* if the butten did say 'unfollow', then we want to unfollow, and
            switch the label
        */
        if sender.titleLabel?.text == "unfollow" {
            // unfollow
            GitHubCommunicator().unfollow(user: user.username, { (success) in
                DispatchQueue.main.async {
                    if success {
                        sender.setTitle("follow", for: .normal)
                        sender.setTitleColor(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), for: .normal)
                    } else {
                        // UI ALERT
                    }
                }
            })
            
        } else {
            // follow
            GitHubCommunicator().follow(user: user.username, { (success) in
                DispatchQueue.main.async {
                    if success {
                        sender.setTitle("unfollow", for: .normal)
                        sender.setTitleColor(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), for: .normal)
                    } else {
                        // UI ALERT
                    }
                }
            })
        
        }
    }
    
    
    /**
     Called when user selects one of the cells
     
     - Parameters:
     - segue: the segue to follow
     - sender: the button or cell that triggered the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass the profile to display to the profile VC
        if segue.identifier == "toProfileFromFollowing" ,
            let nextScene = segue.destination as? ProfileViewController ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedUser = profiles[indexPath.row]
            nextScene.profile = selectedUser
        }
    }

}



/// extension that conforms to the UITableViewDelegate protocol
extension FollowingFollowerViewController: UITableViewDelegate {
    
    /**
     Is called when the user taps on a row in the tableview
     
     - Parameters:
     - tableView: our classes tableview
     - indexPath: the row that was tapped
     
     - Returns: the number of rows for a given section
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



/// extension that conforms to the UITableViewDataSource protocol
extension FollowingFollowerViewController: UITableViewDataSource {
    
    /**
     Calculates the number of rows in a section
     
     - Parameters:
     - tableView: our classes tableview
     - section: which section the count is for
     
     - Returns: the number of rows for a given section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profiles.count
    }
    
    /**
     Re-uses a cell and fills its info
     
     - Parameters:
     - tableView: our classes tableview
     - indexPath: the particular row
     
     - Returns: a cell with updated info
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as? FollowInfoTableViewCell else {
            return FollowInfoTableViewCell()
        }
    
        buttonMap[cell.followButton] = profiles[indexPath.row]
        
        // make profile image view round
        cell.followUserProfileImage.layer.cornerRadius = cell.followUserProfileImage.frame.size.width/2
        cell.followUserProfileImage.layer.masksToBounds = true
        
        // follow/unfollow buttons
        
        if source == "following" {
            // set buttons to 'unfollow'
            cell.followButton.setTitle("unfollow", for: .normal)
            cell.followButton.setTitleColor(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), for: .normal)

        } else {
            
            if GitHubViewer.contains(obj: profiles[indexPath.row], inArray: self.usersIFollow) {
                
                cell.followButton.setTitle("unfollow", for: .normal)
                cell.followButton.setTitleColor(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), for: .normal)

            } else {
                cell.followButton.setTitle("follow", for: .normal)
                cell.followButton.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), for: .normal)
            }
            
        }
        
        // get user for this row
        let user = profiles[indexPath.row]
        cell.followUserNameLabel.text = "@"+user.username
        
        // check if we have the users avatar url, if so try to fetch the profile pic
        if !user.avatarUrl.isEmpty  {
            user.getProfilePic { (profilePic) in
                DispatchQueue.main.async {
                    if (profilePic != nil) {
                        cell.followUserProfileImage.image = profilePic
                    } else {
                        cell.followUserProfileImage.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    }
                }
            }
        } else {
            cell.followUserProfileImage.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        return cell
    }
}
