//
//  Utilities.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/21/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import UIKit


/**
 Creates a UIAlert and displays it on the ViewController passed in
 
 - Parameters:
 - message: Tme message to display in the Alert
 - title: The title to display on the Alert
 - viewController: The view controller on which to display the message
 
 */
func alert(message: String, title: String = "", viewController: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(OKAction)
    viewController.present(alertController, animated: true, completion: nil)
}


/**
 Helper function to tell if a profile is in an arr
 
 - Parameters:
 - obj: the obj to see if its in arr
 - arr: the array to search
 */
func contains(obj: GitHubProfile, inArray arr: [GitHubProfile]) -> Bool {
    for element in arr {
        if element.username == obj.username {
            return true
        }
    }
    return false
}
