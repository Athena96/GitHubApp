//
//  GitHubCommunicatorTests.swift
//  GitHubAppTests
//
//  Created by Jared Franzone on 10/22/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import XCTest

@testable import GitHubViewer

class GitHubCommunicatorTests: XCTestCase {
    
    var comm = GitHubCommunicator()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testFetchProfileData() {
        
        comm.fetchProfileDataFor(user: "athena96") { (gitHubProfile, error)  in
            XCTAssert(gitHubProfile != nil)
            XCTAssert(gitHubProfile?.name == "Jared Franzone")
            XCTAssert(gitHubProfile?.username == "Athena96")
        }
        
    }
    
    
    func testFetchProfileImage() {

        comm.fetchProfileImageFrom(url: "https://avatars1.githubusercontent.com/u/14256844?v=4") { (imageData) in
            
            XCTAssert(imageData != nil)
            XCTAssert(UIImage(data: imageData!) != nil)
        }
        
    }
    
    func testFetchRepoData() {
        
        comm.fetchRepositoriesFor(user: "athena96") { (repos, error) in
            XCTAssert(repos != nil)
            XCTAssert((repos?.count)! >= 3)
        }
        
    }
    
    func testFetchFollowData() {
        comm.fetchFollowInformationFor(user: "athena96", followOrFollowing: "followers") { (followers, error) in
            XCTAssert(followers != nil)
            XCTAssert((followers?.count)! >= 2)

        }
    }
    
    func testFollowUnfollowUser() {
        Profile.shared.username = "athena96"
        Profile.shared.pass = "bu9485si"
        
        let username = "mhahsler"
        
        comm.follow(user: username) { (success) in
            XCTAssertTrue(success)
        }
        
        comm.unfollow(user: username) { (success) in
            XCTAssertTrue(success)
        }
        
    }
    
    
}
