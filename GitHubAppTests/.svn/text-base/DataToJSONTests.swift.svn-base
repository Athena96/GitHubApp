//
//  DataToJSONTests.swift
//  GitHubAppTests
//
//  Created by Jared Franzone on 10/22/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import XCTest
@testable import GitHubViewer

class DataToJSONTests: XCTestCase {
    
    var network = Networking()
    var converter = DataToJSON()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method inx the class.
        super.tearDown()
    }
    
    
    func testDataToSingleJsonObject() {
        network.requestFor(url: "https://api.github.com/users/athena96", withBody: nil, andHeaders: nil, ofType: "GET") { (data, error) in
            
            XCTAssert(data != nil)
            

            let json = self.converter.dataToJson(data: data!)
            
            XCTAssert(json != nil)
        }
        
    }
    
    func testDataToArrayOfJsonObjects() {
        
        network.requestFor(url: "https://api.github.com/users/athena96/followers", withBody: nil, andHeaders: nil, ofType: "GET") { (data, error)  in
            
            XCTAssert(data != nil)
            
            
            let json = self.converter.dataToArrayOfJson(data: data!)
            
            XCTAssert(json != nil)
            
        }
        
    }
    

}
