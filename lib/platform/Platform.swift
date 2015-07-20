import Foundation

// delete setversion

/// Platform used to call HTTP request methods.
class Platform {
    
    // Platform credentials
    var auth: Auth?
    let server: String
    let appKey: String
    let appSecret: String
    
    /// Constructor for the platform of the SDK
    ///
    /// :param: appKey      The appKey of your app
    /// :param: appSecet    The appSecret of your app
    /// :param: server      Choice of PRODUCTION or SANDBOX
    init(appKey: String, appSecret: String, server: String) {
        self.appKey = appKey
        self.appSecret = appSecret
        self.server = server
    }
    
    
    /// Authorizes the user with the correct credentials
    ///
    /// :param: username    The username of the RingCentral account
    /// :param: password    The password of the RingCentral account
    func authorize(username: String, password: String, remember: Bool = true) {
        let authHolder = Auth(username: username, password: password, server: server)
        let feedback = authHolder.login(appKey, secret: appSecret)
        if (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2 {
            self.auth = authHolder
        }
    }
    
    
    
    /// Authorizes the user with the correct credentials (with extra ext)
    ///
    /// :param: username    The username of the RingCentral account
    /// :param: password    The password of the RingCentral account
    /// :param: ext         The extension of the RingCentral account
    func authorize(username: String, ext: String, password: String) {
        let authHolder = Auth(username: username, ext: ext, password: password, server: self.server)
        let feedback = authHolder.login(appKey, secret: appSecret)
        if (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2 {
            self.auth = authHolder
        }
    }
    
    
    /// Refreshes the Auth object so that the accessToken and refreshToken are updated.
    ///
    /// **Caution**: Refreshing an accessToken will deplete it's current time, and will
    /// not be appended to following accessToken.
    func refresh() {
        if let holder: Auth = self.auth {
            self.auth!.refresh()
        } else {
            notAuthorized()
        }
    }
    
    
    /// Logs the user out of the current account.
    ///
    /// Kills the current accessToken and refreshToken.
    func logout() {
        auth!.revokeToken()
    }
    
    
    /// Returns whether or not the current accessToken is valid.
    ///
    /// :return: A boolean to check the validity of token.
    func isTokenValid() -> Bool {
        return false
    }
    
    
    /// Returns whether or not the current Platform has been authorized with a user.
    ///
    /// :return: A boolean to check the validity of authorization.
    func isAuthorized() -> Bool {
        return auth!.isAccessTokenValid()
    }
    
    /// Tells the user that the platform is not yet authorized.
    ///
    ///
    func notAuthorized() {
        
    }

    
    // Generic Method Calls
    
    func get(url: String, query: [String: String] = ["": ""]) {
        apiCall([
            "method": "GET",
            "url": url,
            "query": query
            ])
    }
    
    func put(url: String, body: String = "") {
        apiCall([
            "method": "PUT",
            "url": url,
            "body": body
            ])
    }
    
    func post(url: String, body: String = "") {
        apiCall([
            "method": "POST",
            "url": url,
            "body": body
            ])
    }
    
    func delete(url: String) {
        apiCall([
            "method": "DELETE",
            "url": url,
            ])
    }
    
    //    func apiCall(verb: String, url: String, query: [String: String] = ["": ""], body: String = "") {
    //        var request = Request(method: verb, url: url, query: query, body: body, auth: auth)
    //        request.send()
    //    }
    
    func apiCall(options: [String: AnyObject]) {
        var method = ""
        var url = ""
        var headers: [String: String] = ["": ""]
        var query: [String: String]?
        var body: String = ""
        if let m = options["method"] as? String {
            method = m
        }
        if let u = options["url"] as? String {
            url = self.server + u
        }
        if let h = options["headers"] as? [String: String] {
            headers = h
        }
        if let q = options["query"] as? [String: String] {
            query = q
        }
        if let b = options["body"] as? String {
            body = b
        }
        var request = Request(method: method, url: url, headers: headers, query: query, body: body)
        
        request.setHeader("Content-Type", value: "application/json;charset=UTF-8")
        request.setHeader("Accept", value: "application/json")
        request.setHeader("Authorization", value: "Bearer" + " " + auth!.getAccessToken())
        request.send()
        
        //        var request = Request(method: options["method"] as! String, url: options["url"] as! String, headers: options["headers"] as! [String: String], query: options["query"] as! [String: String], body: options["body"] as! String)
        
    }
    
    func apiCall(options: [String: AnyObject], completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        var method = ""
        var url = ""
        var headers: [String: String] = ["": ""]
        var query: [String: String]?
        var body: String = ""
        if let m = options["method"] as? String {
            method = m
        }
        if let u = options["url"] as? String {
            url = self.server + u
        }
        if let h = options["headers"] as? [String: String] {
            headers = h
        }
        if let q = options["query"] as? [String: String] {
            query = q
        }
        if let b = options["body"] as? String {
            body = b
        }
        var request = Request(method: method, url: url, headers: headers, query: query, body: body)
        
        request.setHeader("Content-Type", value: "application/json;charset=UTF-8")
        request.setHeader("Accept", value: "application/json")
        request.setHeader("Authorization", value: "Bearer" + " " + auth!.getAccessToken())
        request.send() {
            (data, response, error) in
            completion(data: data, response: response, error: error)
        }
        
        //        var request = Request(method: options["method"] as! String, url: options["url"] as! String, headers: options["headers"] as! [String: String], query: options["query"] as! [String: String], body: options["body"] as! String)
        
    }
    
    func testApiCall() {
        apiCall([
            "method": "POST",
            "url": "/v1.0/account/~/extension/~/ringout",
            "body": ringOutSyntax("4088861168", from: "4088861168")
            ])
        
        var context = Swift.Dictionary<String, Any>()
        context["method"] = "POST"
        context["url"] = "/v1.0/account/~/extension/~/ringout"
        context["body"] = ["to": ["phoneNumber": "14088861168"],
            "from": ["phoneNumber": "14088861168"],
            "callerId": ["phoneNumber": "13464448343"],
            "playPrompt": "true"]

    }
    
    func ringOutSyntax(to: String, from: String) -> String {
        return "{" +
            "\"to\": {\"phoneNumber\": \"" +
            to +
            "\"}," +
            "\"from\": {\"phoneNumber\": \"" +
            from +
            "\"}," +
            "\"callerId\": {\"phoneNumber\": \"" +
            auth!.getUsername() +
            "\"}," +
            "\"playPrompt\": true" +
        "}"
    }
    
    
    // Manual testing
    
    //    func test() {
    //        CallLog(server: self.server).callLog(self.auth!)
    //        CallLog(server: self.server).callLogExt(self.auth!)
    //        CallLog(server: self.server).activeCalls(self.auth!)
    //        CallLog(server: self.server).activeCallsExt(self.auth!)
    //
    //    }
    //
    //    func test2() {
    //        Messaging(server: self.server).sms(self.auth!, text: "testing", to: "14089406669")
    //    }
    //
    //    func test3() {
    //        Messaging(server: self.server).getMessages(self.auth!)
    //        Messaging(server: self.server).getMessage(self.auth!, msgId: "2394843412560562429")
    //    }
    //
    //    func test4() {
    //        RingOut(server: self.server).ringOut(self.auth!, from: "14088861168", to: "14088861168")
    //    }
    //
    //
    //    // Faulty
    //    func test5() {
    //        RingOut(server: self.server).getRingOut(self.auth!, ringId: "131069004")
    //    }
    //
    //    func test6() {
    //        Presence(server: self.server).getPresence(self.auth!)
    //    }
    //
    //    // Note to self, ADDRESS BOOK DOES NOT WORK
    //
    //    func test7() {
    //        Dictionary(server: self.server).getCountry(auth!)
    //        Dictionary(server: self.server).getCountries(auth!)
    //        Dictionary(server: self.server).getLanguage(auth!)
    //        Dictionary(server: self.server).getLanguages(auth!)
    //        Dictionary(server: self.server).getState(auth!)
    //        Dictionary(server: self.server).getTimezone(auth!)
    //        Dictionary(server: self.server).getTimezones(auth!)
    //        
    //    }
    //    
    
}