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
    
    func test3_Auth() {
        let username = "13464448343"
        let password = "P@ssw0rd"
        platform.authorize(username, password: password)
        var auth = platform.auth
        XCTAssertEqual(auth!.authenticated, true)
        XCTAssertNotEqual(auth!.expires_in, 0)
        XCTAssertNotEqual(auth!.expire_time, 0)
        XCTAssertNotEqual(auth!.refresh_token_expires_in, 0)
        XCTAssertNotEqual(auth!.refresh_token_expire_time, 0)
        XCTAssertEqual(auth!.ext, "101")
    }
    
    func test4_RingOut() {
        
    }
    
    func test5_SMS() {
        
    }
    
    func test6_CallLog() {
        
    }
    
    func test7_Account() {
        
    }
    
    func test8_Messaging() {
        
    }
    
    func test9_Presence() {
        
    }
    
    func test10_Dictionary() {
        
    }
    
    func test11_Subscription() {
        
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
