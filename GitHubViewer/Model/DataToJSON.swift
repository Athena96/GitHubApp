//
//  DataToJSON.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/22/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation

/// Struct responsible for converting Data() to JSON (Dictionary)
struct DataToJSON {
    
    /**
     Converts Data to JSON
     
     - Parameter data: of type Data
     - Returns: a Swift Dictionary with key: String and Value of type Any... Or nil if conversion not successful
     */
    func dataToJson(data: Data) -> [String:Any]? {
        do {
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return json
            }
            
            return nil
            
        } catch {
            
            return nil
        
        }
    }
    

    /**
     Converts Data to array of JSON
     
     - Parameter data: of type Data
     - Returns: a Swift Dictionary with key: String and Value of type Any... Or nil if conversion not successful
     */
    func dataToArrayOfJson(data: Data) -> [[String:Any]]? {
        do {
            
            if let arrayOfJsonObjects = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                return arrayOfJsonObjects
            }
            return nil
            
        } catch {
            
            return nil
        
        }
    }
    
}


