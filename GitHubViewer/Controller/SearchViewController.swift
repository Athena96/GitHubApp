//
//  SearchViewController.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 12/20/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit

/// VC class responsible for search/display of GitHub for users and repos
class SearchViewController: UIViewController, UISearchBarDelegate {

    /// table view for displaying content
    @IBOutlet weak var tableView: UITableView!
    
    /// search bar
    @IBOutlet weak var search: UISearchBar!
    
    /// segmented control to choose between searching users/repos
    @IBOutlet weak var searchChoiceSegmentControl: UISegmentedControl!
    
    /// the datasource for the table view (holds either profiles or repos)
    var searchResults = [Any]()
    
    
    /**
     Called once when view first loads
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
    }

    /**
     called when the 'search' or 'return' button on the keyboard is pressed
     
     - Parameters:
     - searchBar: the search bar itself
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // close the keyboard
        searchBar.endEditing(true)
        
        // get the search parameters
        var searchTerm = (searchBar.text)!
        let sortOrder = (searchChoiceSegmentControl.selectedSegmentIndex == 0) ? "followers" : "stars"
        let params = [("q",searchTerm), ("sort", sortOrder), ("order","desc")]
        
        // decide if its a User or Repo Search
        if searchChoiceSegmentControl.selectedSegmentIndex == 0  {
            
            // Search Users
            GitHubCommunicator().search(user: searchTerm, withParameters: params) { (searchResults) in
                DispatchQueue.main.async {
                    // update the UI
                    self.searchResults.removeAll()
                    self.searchResults = searchResults!
                    self.tableView.reloadData()
                }
            }
            
        } else {
            
            // Search Repos
            GitHubCommunicator().search(repository: searchTerm, withParameters: params, { (searchResults) in
                DispatchQueue.main.async {
                    // update the UI
                    self.searchResults.removeAll()
                    self.searchResults = searchResults!
                    self.tableView.reloadData()
                }
            })
        }
        
    }
    
    
    /**
     called when the user switches between searching users/repos
     
     - Parameters:
     - searchBar: the search bar itself
     */
    @IBAction func searchTypeChanged(_ sender: UISegmentedControl) {
        self.searchResults.removeAll()
        self.tableView.reloadData()
    }
    
    
    /**
     called before a segue is about to happen, decides whether or not to
     perform the segue. if user is trying to select a repo, we do not do any
     segues
     
     - Parameters:
     - identifier: id of segue
     - sender: selector of the segue
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (searchResults[(tableView.indexPathForSelectedRow?.row)!] as? (String,String)) == nil ||
            searchChoiceSegmentControl.selectedSegmentIndex == 1 {
            return false
        } else {
            return true
        }
    }
    
    /**
     Called when user selects one of the users in the cell
     
     - Parameters:
     segue: the segue to follow
     sender: the button or cell that triggered the segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass the profile to display to the profile VC
        
        if searchChoiceSegmentControl.selectedSegmentIndex == 0 {
            
            if segue.identifier == "toProfileView" ,
                let nextScene = segue.destination as? ProfileViewController ,
                let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedUser = (searchResults[indexPath.row] as! (String,String)).0
                
                GitHubCommunicator().fetchProfileDataFor(user: selectedUser, { (fetchedProfile, error) in
                    
                    DispatchQueue.main.async {
                        nextScene.profile = fetchedProfile!
                    }
                    
                })
                
            }
        }
        
        return
        
    }

}


/// extension that conforms to the UITableViewDelegate protocol
extension SearchViewController: UITableViewDelegate {
    
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
extension SearchViewController: UITableViewDataSource {
    
    /**
     Calculates the number of rows in a section
     
     - Parameters:
     - tableView: our classes tableview
     - section: which section the count is for
     
     - Returns: the number of rows for a given section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    /**
     Re-uses a cell and fills its info.
     
     - Parameters:
     - tableView: our classes tableview
     - indexPath: the particular row
     
     - Returns: a cell with updated info
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        if self.searchChoiceSegmentControl.selectedSegmentIndex == 0 {
            cell.textLabel?.text = (searchResults[indexPath.row] as! (String,String)).0
            cell.detailTextLabel?.text = ""
        } else {
            cell.textLabel?.text =  (searchResults[indexPath.row] as! (String,String, String)).0
            cell.detailTextLabel?.text = (searchResults[indexPath.row] as! (String,String, String)).2
        }
        
        return cell
    }
}
