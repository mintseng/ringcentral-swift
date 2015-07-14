//
//  Response.swift
//  demo
//
//  Created by Vincent Tseng on 7/8/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import Foundation

class Response: Headers {
    
//    init(status: String, statusText: String, body: String, headers: String) {
//        
//    }
    
    var status: Int!
    var statusText: String!
    var body: String!
    
    var data: NSData?
    var response: NSURLResponse?
    var error: NSError?
    
    init(data: NSData, response: NSURLResponse, error: NSError?) {
        if let check = error {
            super.init()
        } else {
            let feedback = (response as! NSHTTPURLResponse)
            super.init(options: feedback.allHeaderFields)
            status = feedback.statusCode
        }

        statusText = ""
        body = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
    }
    
    func checkStatus() -> Bool {
        return status >= 200 && status < 300
    }
    
    func getBody() -> String {
        return body
    }
    
    func getResponse() -> NSURLResponse? {
        return response
    }
    
    func getData() -> NSData? {
        return data
    }
    
    func getData() -> String {
        return body
    }
    
//    func getJson()
    
//    func getResponses()
    
    func getStatus() -> Int {
        return status
    }
    
    func getStatusText() -> String {
        return statusText
    }
    
    func getError() -> String {
        if let x = error {
            return x.description
        } else {
            return ""
        }
    }
    
    func getError() -> NSError? {
        return error
    }
    
}