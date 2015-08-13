import Foundation

class Request: Headers {
    
    var async = true
    var method: String = ""
    var url: String = ""
    var query: String = ""
    var body: AnyObject = ""
    
    /// Initializes a general header object for HTTP requests
    ///
    /// :param: method      The type of HTTP verb for the request
    /// :param: url         The url address of HTTP call
    /// :param: headers     The header fields of the HTTP request
    /// :param: query       Options to add onto URL
    /// :param: body        The body of the HTTP request
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
    
    /// Gets the body of the HTTP request
    ///
    /// :return: NSData of the HTTP request body
    func getEncodedBody() -> NSData! {
        return body.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    /// Checks if request is a POST
    ///
    /// :returns: Bool of if request is a POST
    func isPost() -> Bool {
        return method == "POST"
    }
    
    /// Checks if request is a GET
    ///
    /// :returns: Bool of if request is a GET
    func isGet() -> Bool {
        return method == "GET"
    }
    
    /// Checks if request is a PUT
    ///
    /// :returns: Bool of if request is a PUT
    func isPut() -> Bool {
        return method == "PUT"
    }
    
    /// Checks if request is a DELETE
    ///
    /// :returns: Bool of if request is a DELETE
    func isDelete() -> Bool {
        return method == "DELETE"
    }
    
    /// Gets the type of HTTP request
    ///
    /// :returns: String of HTTP request method
    func getMethod() -> String {
        return method
    }
    
    /// Sets the type of HTTP request
    func setMethod(verb: String) {
        method = verb
    }
    
    /// Gets the HTTP request URL
    ///
    /// :returns: String of the HTTP request URL
    func getUrl() -> String {
        return url
    }
    
    /// Sets the HTTP request URL
    ///
    /// :param: url         URL for HTTP request
    func setUrl(url: String) {
        self.url = url
    }
    
    /// Gets the HTTP request query
    ///
    /// :returns: String of the HTTP request query
    func getQuery() -> String {
        return query
    }
    
    /// Sets the HTTP request query
    ///
    /// :param: query       Query for the HTTP request
    func setQuery(query: String) {
        self.query = query
    }
    
    /// Sends the current HTTP request
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
    
    /// Sends the current HTTP request with a completion handler
    ///
    /// :param: completion      Completion handler for sending the HTTP request
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
    
    /// Converts a 'json' to 'String' representation
    ///
    /// :param: json        JSON being converted
    /// :returns: String of 'json' representation
    private func jsonToString(json: [String: AnyObject]) -> String {
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