import Foundation

/// Platform used to call HTTP request methods.
class Platform {
    
    // Platform credentials
    var auth: Auth?
    let server: String
    let appKey: String
    let appSecret: String
    var subscription: Subscription?
    
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
    
    /// HTTP request method for GET
    ///
    /// :param: url         URL for GET request
    /// :param: query       List of queries for GET request
    func get(url: String, query: [String: String] = ["": ""]) {
        apiCall([
            "method": "GET",
            "url": url,
            "query": query
            ])
    }
    
    /// HTTP request method for PUT
    ///
    /// :param: url         URL for PUT request
    /// :param: body        Body for PUT request
    func put(url: String, body: String = "") {
        apiCall([
            "method": "PUT",
            "url": url,
            "body": body
            ])
    }
    
    /// HTTP request method for POST
    ///
    /// :param: url         URL for POST request
    /// :param: body        Body for POST request
    func post(url: String, body: String = "") {
        apiCall([
            "method": "POST",
            "url": url,
            "body": body
            ])
    }
    
    /// HTTP request method for DELETE
    ///
    /// :param: url         URL for DELETE request
    func delete(url: String) {
        apiCall([
            "method": "DELETE",
            "url": url,
            ])
    }
    
    /// Generic HTTP request
    ///
    /// :param: options     List of options for HTTP request
    func apiCall(options: [String: AnyObject]) {
        var method = ""
        var url = ""
        var headers: [String: String] = ["": ""]
        var query: [String: String]?
        var body: AnyObject = ""
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
        if let b = options["body"] {
            if let check = b as? NSDictionary {
                body = check
            } else {
                body = b as! String
            }
        }
        var request = Request(method: method, url: url, headers: headers, query: query, body: body)
        
        request.setHeader("Authorization", value: "Bearer" + " " + auth!.getAccessToken())
        request.send()
    }
    
    /// Generic HTTP request with completion handler
    ///
    /// :param: options         List of options for HTTP request
    /// :param: completion      Completion handler for HTTP request
    func apiCall(options: [String: AnyObject], completion: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        var method = ""
        var url = ""
        var headers: [String: String] = ["": ""]
        var query: [String: String]?
        var body: AnyObject = ""
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
        if let b = options["body"] {
            if let check = b as? NSDictionary {
                body = check
            } else {
                body = b as! String
            }
        }
        var request = Request(method: method, url: url, headers: headers, query: query, body: body)
        request.setHeader("Authorization", value: "Bearer" + " " + auth!.getAccessToken())
        request.send() {
            (data, response, error) in
            completion(data: data, response: response, error: error)
        }

    }
    
    // ringout
    func testApiCall() {
        apiCall([
            "method": "POST",
            "url": "/restapi/v1.0/account/~/extension/~/ringout",
            "body": ["to": ["phoneNumber": "14088861168"],
                "from": ["phoneNumber": "14088861168"],
                "callerId": ["phoneNumber": "13464448343"],
                "playPrompt": "true"]
            ])
        sleep(5)

    }
    
    // fax
    func testApiCall2() {
        apiCall([
            "method": "POST",
            "url": "/restapi/v1.0/account/~/extension/~/fax",
            "body": "--Boundary_1_14413901_1361871080888\n" +
                "Content-Type: application/json\n" +
                "\n" +
                "{\n" +
                "  \"to\":[{\"phoneNumber\":\"13464448343\"}],\n" +
                "  \"faxResolution\":\"High\",\n" +
                "  \"sendTime\":\"2013-02-26T09:31:20.882Z\"\n" +
                "}\n" +
                "\n" +
                "--Boundary_1_14413901_1361871080888\n" +
                "Content-Type: text/plain\n" +
                "\n" +
                "Hello, World!\n" +
                "\n" +
                "--Boundary_1_14413901_1361871080888--",
            "headers": ["Content-Type": "multipart/mixed;boundary=Boundary_1_14413901_1361871080888"]
            ]) {
                (data, response, error) in
                println(response)
                println(error)
                println(NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary)
        }
        sleep(5)
    }
    
    // subscription
    func testApiCall3() {
        apiCall([
            "method": "POST",
            "url": "/restapi/v1.0/subscription",
            "body": [
                "eventFilters": [
                    "/restapi/v1.0/account/~/extension/~/presence",
                    "/restapi/v1.0/account/~/extension/~/message-store"
                ],
                "deliveryMode": [
                    "transportType": "PubNub", 
                    "encryption": "false" 
                ]
            ]
        ]) {
            (data, response, error) in
            println(response)
            println(error)
            println(NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary)
        }
        sleep(5)
    }
    
    func testSubCall() {
        self.subscription = Subscription(platform: self)
        subscription!.register()
        
    }

    
}
