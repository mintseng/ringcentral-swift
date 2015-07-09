//
//  Headers.swift
//  demo
//
//  Created by Vincent Tseng on 7/8/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import Foundation

class Headers {
    
    var contentType = "Content-Type"
    var jsonContentType = "aplication/json;"
    var multipartContentType = "multipart/mixed;"
    var urlencodedContentType = "application/x-www-form-urlencoded;"
    var utf8ContentType = "charset=UTF-8;"
    
    var values: [String: String] = [String:String]()
    
    init(options: [String: String]) {
        
    }
    
    func getHeader(name: String) -> String! {
        if hasHeader(name) {
            return values[name]
        } else {
            return ""
        }
    }
    
    func hasHeader(name: String) -> Bool {
        if let x = values[name] {
            return true
        } else {
            return false
        }
        
    }
    
    func setHeader(name: String!, value: String!) {
        values[name] = value
    }
    
    func setHeaders(headers: [String: String]) {
        for name in headers.keys {
            setHeader(name, value: headers[name])
        }
    }
    
    func isContentType(type: String) -> Bool {
        for value in getContentType().componentsSeparatedByString(",") {
            if value == type {
                return true
            }
        }
        return false
    }
    
    func getContentType() -> String! {
        if let x = values["Content-Type"] {
            return x
        } else {
            return ""
        }
    }
    
    func isMultipart() -> Bool {
        return isContentType(multipartContentType)
    }
    
    func isUrlEncoded() -> Bool {
        return isContentType(urlencodedContentType)
    }
    
    func isJson() -> Bool {
        return isContentType(jsonContentType)
    }
    
}