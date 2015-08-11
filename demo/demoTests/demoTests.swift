import UIKit
import XCTest


class demoTests: XCTestCase {
    
    var rcsdk: SDK!
    var platform: Platform!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let appKey = "eI3RKs1oSBSY2kReFnviIw"
        let appSecret = "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ"
        rcsdk = SDK(appKey: appKey, appSecret: appSecret, server: SDK.RC_SERVER_SANDBOX)
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
    
    func testAA_subscription() {
        platform.testSubCall()
        sleep(10)
    }
    
    func testA_Sdk() {
        XCTAssertEqual(rcsdk.serverVersion, "7.2.0.1787")
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
    
//    func testD_RingOut() {
//        XCTAssertEqual(platform.postRingOut("13464448343", to: "13464448343"), true)
//    }
//    
//    func testE_Presence() {
//        var feedback = platform.getPresence()
//        let check = (NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary)
//        XCTAssertEqual(check["presenceStatus"] as! String, "Busy")
//        XCTAssertEqual(check["telephonyStatus"] as! String, "CallConnected")
//        XCTAssertEqual(check["userStatus"] as! String, "Available")
//    }
//    
//    func testF_SMS() {
//        XCTAssertEqual(platform.postSms("testing " + (Int(NSDate().timeIntervalSince1970) / 10000).description, to: "13464448343"), true)
//    }
//    
//    func testG_Account() {
//        var feedback = platform.getAccountId()
//        let check = (NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary)["id"] as! NSNumber
//        XCTAssertEqual(check, 131069004)
//    }
//    
//    func testH_Messaging() {
//        var feedback = platform.getMessages()
//        var message = ((NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary) ["records"]! as! NSArray)[0]
//        
//        XCTAssertEqual((message["from"] as! NSDictionary) ["phoneNumber"] as! String, "+13464448343")
//        XCTAssertEqual(message["direction"] as! String, "Inbound")
//        XCTAssertEqual(message["subject"] as! String, "testing " + (Int(NSDate().timeIntervalSince1970) / 10000).description)
//        
//        message = ((NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary) ["records"]! as! NSArray)[1]
//        
//        XCTAssertEqual((message["to"] as! NSArray)[0]["phoneNumber"] as! String, "+13464448343")
//        XCTAssertEqual(message["direction"] as! String, "Outbound")
//        XCTAssertEqual(message["subject"] as! String, "testing " + (Int(NSDate().timeIntervalSince1970) / 10000).description)
//    }
//    
//    func testI_Dictionary() {
//        var feedback = platform.getCountries()
//        var data = NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary
//        var check = ((data["records"] as! NSArray)[0] as! NSDictionary)["name"] as! String
//        XCTAssertEqual(check, "Afghanistan")
//    }
//    
//    func testJ_CallLog() {
//        var feedback = platform.getCallLog(true)["records"] as! NSArray
//        XCTAssertEqual(feedback[0]["result"] as! String, "Missed")
//        XCTAssertEqual(feedback[0]["direction"] as! String, "Inbound")
//        let check1 = (feedback[0]["to"] as! NSDictionary)["phoneNumber"] as! String
//        XCTAssertEqual(check1, "+13464448343")
//        let check2 = (feedback[0]["from"] as! NSDictionary)["phoneNumber"] as! String
//        XCTAssertEqual(check2, "+13464448343")
//        
//        XCTAssertEqual(feedback[1]["result"] as! String, "Call connected")
//        XCTAssertEqual(feedback[1]["direction"] as! String, "Outbound")
//        let check3 = (feedback[1]["to"] as! NSDictionary)["phoneNumber"] as! String
//        XCTAssertEqual(check3, "+13464448343")
//        let check4 = (feedback[1]["from"] as! NSDictionary)["phoneNumber"] as! String
//        XCTAssertEqual(check4, "+13464448343")
//    }
//    
//    func testK_Subscription() {
//        
//    }
//    
//    func testL_ApiCall() {
//        if platform.isAuthorized() {
//            platform.apiCall([
//            "method": "POST",
//            "url": "/v1.0/account/~/extension/~/ringout",
//            "body": platform.ringOutSyntax("4088861168", from: "4088861168")
//            ])
//        } else {
//            
//        }
//        
//    }
//    
//    func testM_ApiCallResponse() {
//        platform.apiCall([
//            "method": "POST",
//            "url": "/v1.0/account/~/extension/~/ringout",
//            "body": platform.ringOutSyntax("4088861168", from: "4088861168")
//            ]) { (data, response, error) in
//                
//                
//                println("start")
//                println(NSString(data: data!, encoding: NSUTF8StringEncoding))
//                println(response)
//                println(error)
//                println("success!")
//                
//                println("part2")
//                var feedback = Response(data: data, response: response!, error: error)
//                println(feedback.getBody())
//                println(feedback.getStatus())
//                let testError: String? = feedback.getError()
//                println(testError)
//                println("end")
//                
//        }
//    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
