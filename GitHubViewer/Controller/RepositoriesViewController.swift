//
//  RepositoriesViewController.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/17/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit
import SafariServices
import CloudKit

/// VC class responsible for fetching and displaying the users repository info
class RepositoriesViewController: UIViewController, SFSafariViewControllerDelegate {
    
    /// table view that this class is connected to
    @IBOutlet weak var tableView: UITableView!
    
    /// array of the users public repositories
    var repositories = [GitHubRepository]()
    
    
    /**
     Called once when view first loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /**
     Called everytime the view appears
     - Parameters:
     - animated: to appear animated or not
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if the user is logged in
        guard let username = Profile.shared.username else {
            alert(message: "Need to sign in.", title: "Not Signed In", viewController: self)
            return
        }
        
        loadRepositories(forUser: username)
       
    }
    
    
    /**
     Loads the table view with repositories for 'username'
     
     - Parameters:
     - username: the username to fetch repos for.
     */
    func loadRepositories(forUser username: String) {
        
        // fetch the users repository information
        GitHubCommunicator().fetchRepositoriesFor(user: username) { (fetchedRepos, error) in
            
            // get the main queue so we can update the UI
            DispatchQueue.main.async {
                
                self.repositories.removeAll()
                
                if fetchedRepos != nil{
                    self.repositories = fetchedRepos!
                }
                
                self.tableView.reloadData()
                
            }
        }
        
    }

    
    /**
     Is called in the SF View Controller when the user presses the 'Done' button
     
     - Parameter controller: the SF ViewController
     */
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarView") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
}



/// extension that conforms to the UITableViewDelegate protocol
extension RepositoriesViewController: UITableViewDelegate {
    
    
    /**
     Is called when the user taps on a row in the tableview
     
     - Parameters:
     - tableView: our classes tableview
     - indexPath: the row that was tapped
     
     - Returns: the number of rows for a given section
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repoLink = repositories[indexPath.row].link
        
        if let url = URL(string: repoLink) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}



/// extension that conforms to the UITableViewDataSource protocol
extension RepositoriesViewController: UITableViewDataSource {
    
    
    /**
     Calculates the number of rows in a section
     
     - Parameters:
     - tableView: our classes tableview
     - section: which section the count is for
     
     - Returns: the number of rows for a given section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    
    /**
     Re-uses a cell and fills its info.
     
     - Parameters:
     - tableView: our classes tableview
     - indexPath: the particular row
     
     - Returns: a cell with updated info
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // deque cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as? RepositoryTableViewCell else {
            return RepositoryTableViewCell()
        }
        
        // get the repo
        let repo = repositories[indexPath.row]

        // update cell info
        cell.repoNameLabel.text = repo.name
        cell.authorLabel.text = "@"+repo.owner
        cell.descriptionLabel.text = repo.readMe ?? "No Description"
        
        return cell
    }
}



