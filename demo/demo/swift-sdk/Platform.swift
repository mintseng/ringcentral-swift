import Foundation

/// Platform used to call HTTP request methods.
class Platform {
    
    // Platform credentials
    var auth: Auth?
    let server: String
    let appKey: String
    let appSecret: String
    var version: String = "0"
    
    // Platform tools
    var ringOut: RingOut?
    var messaging: Messaging?
    var callLog: CallLog?
    var presence: Presence?
    var account: Account?
    var dictionary: Dictionary?
    
    
    /// Constructor for the platform of the SDK
    ///
    /// :param: appKey      The appKey of your app
    /// :param: appSecet    The appSecret of your app
    /// :param: server      Choice of PRODUCTION or SANDBOX
    init(appKey: String, appSecret: String, server: String) {
        self.appKey = appKey
        self.appSecret = appSecret
        self.server = server
        setVersion()
    }
    
    
    /// Authorizes the user with the correct credentials
    ///
    /// :param: username    The username of the RingCentral account
    /// :param: password    The password of the RingCentral account
    func authorize(username: String, password: String) {
        auth = Auth(username: username, password: password, server: server)
        let feedback = auth!.login(appKey, secret: appSecret)
        if (feedback.1 as! NSHTTPURLResponse).statusCode == 2 {
            self.ringOut = RingOut(server: server)
            self.messaging = Messaging(server: server)
            self.callLog = CallLog(server: server)
            self.presence = Presence(server: server)
            self.account = Account(server: server)
            self.dictionary = Dictionary(server: server)
        }
    }
    
    
    /// Authorizes the user with the correct credentials (with extra ext)
    ///
    /// :param: username    The username of the RingCentral account
    /// :param: password    The password of the RingCentral account
    /// :param: ext         The extension of the RingCentral account
    func authorize(username: String, ext: String, password: String) {
        auth = Auth(username: username, ext: ext, password: password, server: self.server)
        let feedback = auth!.login(appKey, secret: appSecret)
        if (feedback.1 as! NSHTTPURLResponse).statusCode == 2 {
            self.ringOut = RingOut(server: server)
            self.messaging = Messaging(server: server)
            self.callLog = CallLog(server: server)
            self.presence = Presence(server: server)
            self.account = Account(server: server)
            self.dictionary = Dictionary(server: server)
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
    
    /// Sets the version of the current API
    ///
    ///
    func setVersion() {
        let url = NSURL(string: server + "/")
        
        // Sets up the request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        var response: NSURLResponse?
        var error: NSError?
        let data: NSData! = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errors) as! NSDictionary
        self.version = readdata["serverVersion"] as! String
    }
    
    
    func getAccountInfo() -> Bool {
        var test: Bool = false
        Account(server: self.server).getAccountIdExtensionId(self.auth!)
        test = true
        return test
    }
    
    func test() {
        CallLog(server: self.server).callLog(self.auth!)
        CallLog(server: self.server).callLogExt(self.auth!)
        CallLog(server: self.server).activeCalls(self.auth!)
        CallLog(server: self.server).activeCallsExt(self.auth!)
        
    }
    
    func test2() {
        Messaging(server: self.server).sms(self.auth!, text: "testing", to: "14089406669")
    }
    
    func test3() {
        Messaging(server: self.server).getMessages(self.auth!)
        Messaging(server: self.server).getMessage(self.auth!, msgId: "2394843412560562429")
    }
    
    func test4() {
        RingOut(server: self.server).ringOut(self.auth!, to: "14088861168", from: "14088861168")
    }
    
    
    // Faulty
    func test5() {
        RingOut(server: self.server).getRingOut(self.auth!, ringId: "131069004")
    }
    
    func test6() {
        Presence(server: self.server).getPresence(self.auth!)
    }
    
    // Note to self, ADDRESS BOOK DOES NOT WORK
    
    func test7() {
        Dictionary(server: self.server).getCountry(auth!)
        Dictionary(server: self.server).getCountries(auth!)
        Dictionary(server: self.server).getLanguage(auth!)
        Dictionary(server: self.server).getLanguages(auth!)
        Dictionary(server: self.server).getState(auth!)
        Dictionary(server: self.server).getTimezone(auth!)
        Dictionary(server: self.server).getTimezones(auth!)
    }
    
    
}