//
//  Request.swift
//  demo
//
//  Created by Vincent Tseng on 7/8/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import Foundation

class Request: Headers {
    
    var async = true
    
    var method: String = ""
    var url: String = ""
    var query: String = ""
    var body: String = ""
    
    //    init(method: String, url: String, query: [String: String] = ["": ""], body: String = "") {
    //        self.method = method
    //        self.url = url
    //
    //        for key in query.keys {
    //            self.query = self.query + key + "=" + query[key]! + "&"
    //        }
    //
    //        self.body = body
    //        super.init()
    //    }
    //
    //    init(method: String, url: String, query: [String: String] = ["": ""], body: String = "") {
    //        self.method = method
    //        self.url = url
    //
    //        for key in query.keys {
    //            self.query = self.query + key + "=" + query[key]! + "&"
    //        }
    //
    //        self.body = body
    //        super.init()
    //    }
    
    init(method: String, url: String, headers: [String: String], query: [String: String]?, body: String) {
        super.init()
        self.method = method
        self.url = url
        for header in headers.keys {
            setHeader(header, value: headers[header])
        }
        if let q = query {
            self.query = "?"
            for key in q.keys {
                self.query = self.query + key + "=" + q[key]! + "&"
            }
        }
        
        self.body = body
        
    }
    
    
    
    func getEncodedBody() -> NSData! {
        return body.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    func isPost() -> Bool {
        return method == "POST"
    }
    
    func isGet() -> Bool {
        return method == "GET"
    }
    
    func isPut() -> Bool {
        return method == "PUT"
    }
    
    func isDelete() -> Bool {
        return method == "DELETE"
    }
    
    // func isLoaded()
    
    func getMethod() -> String {
        return method
    }
    
    func setMethod(verb: String) {
        method = verb
    }
    
    func getUrl() -> String {
        return url
    }
    
    func setUrl(url: String) {
        self.url = url
    }
    
    func getQuery() -> String {
        return query
    }
    
    func setQuery(query: String) {
        self.query = query
    }
    
    func send() {
        if let nsurl = NSURL(string: url + self.query) {
            let request = NSMutableURLRequest(URL: nsurl)
            request.HTTPMethod = method
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            let list = getHeaders()
            for key in list.keys {
                request.setValue(list[key], forHTTPHeaderField: key)
            }
            var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
            task.resume()
        }
    }
    
    func send(completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        if let nsurl = NSURL(string: url + self.query) {
            let request = NSMutableURLRequest(URL: nsurl)
            request.HTTPMethod = method
            request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
            let list = getHeaders()
            for key in list.keys {
                request.setValue(list[key], forHTTPHeaderField: key)
            }
            var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data2, response2, error2) in
                completion(data: data2, response: response2, error: error2)
            }
            task.resume()
        }
    }
    
}