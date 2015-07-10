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
    
    var headers: [String: String] = [String:String]()
    
    init() {
        headers["Content-Type"] = urlencodedContentType
        headers["Accept"] = jsonContentType
    }
    
    convenience init(options: [String: String]) {
        self.init()
        for key in options.keys {
            headers[key] = options[key]
        }
    }
    
    func getHeader(name: String) -> String! {
        if hasHeader(name) {
            return headers[name]
        } else {
            return ""
        }
    }
    
    func getHeaders() -> [String: String]! {
        return headers
    }
    
    func hasHeader(name: String) -> Bool {
        if let x = headers[name] {
            return true
        } else {
            return false
        }
    }
    
    func setHeader(name: String!, value: String!) {
        headers[name] = value
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
        if let x = headers["Content-Type"] {
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