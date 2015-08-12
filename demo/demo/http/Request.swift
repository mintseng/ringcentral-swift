import Foundation

class Request: Headers {
    
    var async = true
    
    var method: String = ""
    var url: String = ""
    var query: String = ""
    var body: AnyObject = ""
    
    init(method: String, url: String, headers: [String: String], query: [String: String]?, body: AnyObject) {
        super.init()
        self.method = method
        self.url = url
        setHeader("Content-Type", value: "application/json;charset=UTF-8")
        setHeader("Accept", value: "application/json")
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
        var bodyString: String
        if isJson() {
            bodyString = jsonToString(body as! [String: AnyObject])
        } else {
            bodyString = body as! String
        }

        
        if let nsurl = NSURL(string: url + self.query) {
            let request = NSMutableURLRequest(URL: nsurl)
            request.HTTPMethod = method
            request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
            let list = getHeaders()
            for key in list.keys {
                request.setValue(list[key], forHTTPHeaderField: key)
            }
            var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request)
            task.resume()
        }
    }
    
    func send(completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        var bodyString: String
        if isJson() {
            if body is NSDictionary {
                bodyString = jsonToString(body as! [String: AnyObject])
            } else {
                bodyString = body as! String
            }
            
        } else {
            bodyString = self.body as! NSString as String
        }
        
        if let nsurl = NSURL(string: url + self.query) {
            let request = NSMutableURLRequest(URL: nsurl)
            request.HTTPMethod = method
            request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
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
    

    
    func jsonToString(json: [String: AnyObject]) -> String {
        var result = "{"
        var delimiter = ""
        for key in json.keys {
            result += delimiter + "\"" + key + "\":"
            var item = json[key]
            if let check = item as? String {
                result += "\"" + check + "\""
            } else {
                if let check = item as? [String: AnyObject] {
                    result += jsonToString(check)
                } else if let check = item as? [AnyObject] {
                    result += "["
                    delimiter = ""
                    for item in check {
                        result += "\n"
                        result += delimiter + "\""
                        result += item.description + "\""
                        delimiter = ","
                    }
                    result += "]"
                } else {
                    result += item!.description
                }
            }
            delimiter = ","
        }
        result = result + "}"
        
        return result
    }
    
}