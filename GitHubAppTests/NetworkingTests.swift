//
//  NetworkingTests.swift
//  GitHubAppTests
//
//  Created by Jared Franzone on 10/22/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import XCTest
@testable import GitHubViewer

class NetworkingTests: XCTestCase {
    
    var network = Networking()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testSimpleRequest() {
        
        network.requestFor(url: "https://api.github.com/users/athena96", withBody: nil, andHeaders: nil, ofType: "GET") { (data, error)  in
            
            XCTAssert(data != nil)
            
        }
        
    }
    
    func testRequestWithParameters() {
        
        let urlString = "https://api.github.com/" + "users/" + "athena96" + "/repos"
        let parameters = [("type","all"), ("sort","updated"), ("direction","desc")]
        
        network.requestFor(url: urlString, withBody: parameters, andHeaders: nil, ofType: "GET") { (data, error) in
            
            XCTAssert(data != nil)
        }
        
    }
    
    func testUrlSessionRequest() {
        
        network.sessionFor(url: "https://avatars1.githubusercontent.com/u/14256844?v=4") { (imageData) in
            XCTAssert(imageData != nil)
        }
        
    }
    

    
    
}
