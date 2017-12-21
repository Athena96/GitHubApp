//
//  GitHubProfileTests.swift
//  GitHubAppTests
//
//  Created by Jared Franzone on 10/22/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import XCTest

@testable import GitHubViewer

class GitHubProfileTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testSimpleCreateProfileFromJson() {
        
        var jsonProfile = [String:Any]()
        
        jsonProfile["name"] = "Jared Franzone"
        jsonProfile["public_repos"] = 4
        jsonProfile["followers"] = 2
        jsonProfile["following"] = 2
        jsonProfile["created_at"] = 2
        jsonProfile["bio"] = NSNull()
        jsonProfile["blog"] = "www.jared.com"
        jsonProfile["created_at"] = "05/05/05"
        jsonProfile["login"] = "Athena96"
        jsonProfile["avatar_url"] = "www.url.com/image.jpg"

        let newProfileFromJson = GitHubProfile(json: jsonProfile)
        
        XCTAssert(newProfileFromJson != nil)
        XCTAssert(newProfileFromJson?.name == "Jared Franzone")
        XCTAssert(newProfileFromJson?.publicReposCount == 4)
        XCTAssert(newProfileFromJson?.profileCreateDate == "05/05/05")

    }
    
    
    func testFailInitFromJson() {
        
        var jsonProfile = [String:Any]()
        
        jsonProfile["name"] = nil
        jsonProfile["public_repos"] = 4
        jsonProfile["followers"] = 2
        jsonProfile["following"] = 2
        jsonProfile["created_at"] = 2
        jsonProfile["bio"] = NSNull()
        jsonProfile["blog"] = "www.jared.com"
        jsonProfile["email"] = NSNull()
        jsonProfile["created_at"] = "05/05/05"
        jsonProfile["login"] = nil
        jsonProfile["avatar_url"] = "www.url.com/image.jpg"
        jsonProfile["followers_url"] = "www.someUrl.com"
        jsonProfile["following_url"] = "www.someUrl.com"
        jsonProfile["html_url"] = "www.someUrl.com"
        
        let newProfileFromJson = GitHubProfile(json: jsonProfile)
        
        XCTAssert(newProfileFromJson == nil)
        
    }
    
}
