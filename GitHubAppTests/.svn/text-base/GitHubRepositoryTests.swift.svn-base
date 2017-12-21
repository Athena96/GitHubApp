//
//  GitHubRepositoryTests.swift
//  GitHubAppTests
//
//  Created by Jared Franzone on 10/22/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import XCTest

@testable import GitHubViewer

class GitHubRepositoryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testSimpleCreateRepoFromJson() {
        var jsonRepo = [String:Any]()
        
        var owner = [String:Any]()
        
        owner["name"] = "Jared Franzone"
        owner["public_repos"] = 4
        owner["followers"] = 2
        owner["following"] = 2
        owner["created_at"] = 2
        owner["bio"] = NSNull()
        owner["blog"] = "www.jared.com"
        owner["email"] = NSNull()
        owner["created_at"] = "05/05/05"
        owner["login"] = "Athena96"
        owner["avatar_url"] = "www.url.com/image.jpg"
        owner["followers_url"] = "www.someUrl.com"
        owner["following_url"] = "www.someUrl.com"
        owner["html_url"] = "www.someUrl.com"
        
        jsonRepo["name"] = "Some Repo"
        jsonRepo["owner"] = owner
        jsonRepo["description"] = "This is the description"
        jsonRepo["html_url"] = "www.thelink.com"

        let newRepoFromJson = GitHubRepository(json: jsonRepo)

        XCTAssert(newRepoFromJson != nil)
        XCTAssert(newRepoFromJson?.name == "Some Repo")

        
    }
    
    
    func testFailCreateRepoFromJson() {
        var jsonRepo = [String:Any]()
        
        jsonRepo["name"] = nil
        jsonRepo["owner"] = nil
        jsonRepo["description"] = "This is the description"
        jsonRepo["link"] = "www.thelink.com"
        
        let newRepoFromJson = GitHubRepository(json: jsonRepo)
        
        XCTAssert(newRepoFromJson == nil)
    }
    
    
}
