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
        let username = "13464448343"
        let password = "P@ssw0rd"
        platform.authorize(username, password: password)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sleep(10)
    }
    
    func testA_Sdk() {
        XCTAssertEqual(rcsdk.serverVersion, "7.2.0.1781")
        XCTAssertEqual(rcsdk.versionString, "1.0.18")
        XCTAssertEqual(rcsdk.server, "https://platform.devtest.ringcentral.com/restapi")
    }
    
    func testB_Platform() {
        XCTAssertEqual(platform.server, "https://platform.devtest.ringcentral.com/restapi")
        XCTAssertEqual(platform.appKey, "eI3RKs1oSBSY2kReFnviIw")
        XCTAssertEqual(platform.appSecret, "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ")
    }
    
    func testC_Auth() {
        var auth = platform.auth
        XCTAssertEqual(auth!.authenticated, true)
        XCTAssertNotEqual(auth!.expires_in, 0)
        XCTAssertNotEqual(auth!.expire_time, 0)
        XCTAssertNotEqual(auth!.refresh_token_expires_in, 0)
        XCTAssertNotEqual(auth!.refresh_token_expire_time, 0)
        XCTAssertEqual(auth!.ext, "101")
    }
    
    func testD_RingOut() {
        
    }
    
    func testE_SMS() {
        platform.postSms("testing " + (Int(NSDate().timeIntervalSince1970) / 100).description, to: "13464448343")
    }
    
    func testF_CallLog() {
        platform.getCallLog(true)["records"] as! NSArray
    }
    
    func testG_Account() {
        
    }
    
    func testH_Messaging() {
        var feedback = platform.getMessages()
        var message = ((NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary) ["records"]! as! NSArray)[0]
        
        XCTAssertEqual((message["from"] as! NSDictionary) ["phoneNumber"] as! String, "+13464448343")
        XCTAssertEqual(message["direction"] as! String, "Inbound")
        XCTAssertEqual(message["subject"] as! String, "testing " + (Int(NSDate().timeIntervalSince1970) / 100).description)
        
        message = ((NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary) ["records"]! as! NSArray)[1]
        
        XCTAssertEqual((message["to"] as! NSArray)[0]["phoneNumber"] as! String, "+13464448343")
        XCTAssertEqual(message["direction"] as! String, "Outbound")
        XCTAssertEqual(message["subject"] as! String, "testing " + (Int(NSDate().timeIntervalSince1970) / 100).description)
    }
    
    func testI_Presence() {
        
    }
    
    func testJ_Dictionary() {
        
    }
    
    func testK_Subscription() {
        
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
