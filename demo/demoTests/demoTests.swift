//
//  demoTests.swift
//  demoTests
//
//  Created by Vincent Tseng on 6/25/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import UIKit
import XCTest


class demoTests: XCTestCase {
    
    var rcsdk: Sdk!
    var platform: Platform!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let appKey = "eI3RKs1oSBSY2kReFnviIw"
        let appSecret = "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ"
        let username = "13464448343"
        let password = "P@ssw0rd"
        rcsdk = Sdk(appKey: appKey, appSecret: appSecret, server: Sdk.RC_SERVER_SANDBOX)
        platform = rcsdk.getPlatform()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test1_Sdk() {
        XCTAssertEqual(rcsdk.serverVersion, "7.2.0.1781")
        XCTAssertEqual(rcsdk.versionString, "1.0.18")
        XCTAssertEqual(rcsdk.server, "https://platform.devtest.ringcentral.com/restapi")
        
    }
    
    func test2_Platform() {
        XCTAssertEqual(platform.server, "https://platform.devtest.ringcentral.com/restapi")
        XCTAssertEqual(platform.appKey, "eI3RKs1oSBSY2kReFnviIw")
        XCTAssertEqual(platform.appSecret, "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ")
        
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
