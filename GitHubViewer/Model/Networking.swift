//
//  Networking.swift
//  GitHubViewer
//
//  Created by Jared Franzone on 10/21/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation


/// Struct responsible for making HTTP requests for the GitHubCommunicator struct
struct Networking {
    
    /**
     Executes a simple GET request, with paramaters and calls a completion handler with the fetched data
     
     - Parameter urlString: the url
                 parameters: array of key,val pairs
     
     */
    func requestFor(url urlString: String, withBody body:[(key: String, value: String)]?, andHeaders headers: [(key: String, value: String)]?, ofType type: String,_ completionHandler: @escaping (_ data: Data?, _ error: Error?) -> () ) {
        
        if urlString.isEmpty {
            return
        }
        
        // create URL GET request with users profile url
        let url = URL(string:urlString.replacingOccurrences(of: " ", with: "%20"))
        var request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        //var request = URLRequest(url: url!)
        request.httpMethod = type
        
        // if the user provided parameters, add them
        if let requestBody = body {
            for keyValue in requestBody {
                request.setValue(keyValue.value, forHTTPHeaderField: keyValue.key)
            }
        }
        
        // if the user provided header info, add the info
        if let requestHeaders = headers {
            for keyValue in requestHeaders {
                request.addValue(keyValue.value, forHTTPHeaderField: keyValue.key)
            }
        }
        
        // run this callback when we get a response from the url request
        let session = URLSession.shared
        session.dataTask(with: request) {data, response, err in
            
            completionHandler( data, err)
            
            }.resume()
        
    }
    
    /**
     Executes a simple GET request, but uses a URLSession instead of URL Request, this is used for when you need
         to download a larger file from the web, like an image.
     
     - Parameter urlString: the url
     
     */
    func sessionFor(url urlString: String,_ completionHandler: @escaping (_ data: Data?) -> () ) {
        
        if urlString.isEmpty {
            return
        }
        
        // create URL request using the users image url
        let url = URL(string: urlString)
        
        // run this callback when we get a response from the url request
        let session = URLSession(configuration: .default)
        session.dataTask(with: url!) { (data, response, error) in
            
            completionHandler(data)
            
        }.resume()
        
        
    }
    
    
}
