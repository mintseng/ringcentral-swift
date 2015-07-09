import Foundation

// delete setversion

/// Platform used to call HTTP request methods.
class Platform {
    
    // Platform credentials
    var auth: Auth?
    let server: String
    let appKey: String
    let appSecret: String
    
    // Platform tools
    private var ringOut: RingOut!
    private var messaging: Messaging!
    private var callLog: CallLog!
    private var presence: Presence!
    private var account: Account!
    private var dictionary: Dictionary!
    
    
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
            self.ringOut = RingOut(server: server)
            self.messaging = Messaging(server: server)
            self.callLog = CallLog(server: server)
            self.presence = Presence(server: server)
            self.account = Account(server: server)
            self.dictionary = Dictionary(server: server)
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
            self.ringOut = RingOut(server: server)
            self.messaging = Messaging(server: server)
            self.callLog = CallLog(server: server)
            self.presence = Presence(server: server)
            self.account = Account(server: server)
            self.dictionary = Dictionary(server: server)
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

    
    // Call Log Methods
    
    func getCallLog() -> (NSData?, NSURLResponse?, NSError?) {
        return self.callLog!.callLog(self.auth!)
    }
    
    func getCallLog(query: String) -> (NSData?, NSURLResponse?, NSError?) {
        return self.callLog!.callLog(self.auth!, query: query)
    }
    
    func getCallLogExt() -> (NSData?, NSURLResponse?, NSError?) {
        return self.callLog!.callLogExt(self.auth!)
    }
    
    func getActiveCalls() -> (NSData?, NSURLResponse?, NSError?) {
        return self.callLog!.activeCalls(self.auth!)
    }
    
    func getActiveCallsExt() -> (NSData?, NSURLResponse?, NSError?) {
        return self.callLog!.activeCallsExt(self.auth!)
    }
    
        // Parsers
    
    func getCallLog(parser: Bool) -> NSDictionary {
        let feedback = self.callLog!.callLog(self.auth!)
        return NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary
    }
    
    // RingOut Methods
    
    func postRingOut(from: String, to: String) -> Bool {
        let feedback = ringOut.ringOut(self.auth!, from: from, to: to)
        return (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2
    }
    
    func getRingOut(ringId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return ringOut.getRingOut(self.auth!, ringId: ringId)
    }
    
    func deleteRingOut(ringId: String) -> Bool {
        let feedback = ringOut.deleteRingOut(self.auth!, ringId: ringId)
        return (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2
    }
    
    // Messaging/SMS Methods
    func postSms(text: String, to: String) -> Bool {
        let feedback = messaging.sms(auth!, text: text, to: to)
        return (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2
    }
    
    func getMessage(msgId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return messaging.getMessage(auth!, msgId: msgId)
    }
    
    func getMessages() -> (NSData?, NSURLResponse?, NSError?) {
        return messaging.getMessages(auth!)
    }
    
//    func deleteMessage(msgId: String) -> (NSData?, NSURLResponse?, NSError?) {
//        return messaging.deleteMessage(auth!, msgId: msgId)
//    }
    func deleteMessage(msgId: String) -> Bool {
        let feedback = messaging.deleteMessage(auth!, msgId: msgId)
        return (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2
    }
    
//    func deleteMessaages(convoId: String) -> (NSData?, NSURLResponse?, NSError?) {
//        return messaging.deleteMessages(auth!, convoId: convoId)
//    }
    func deleteMessaages(convoId: String) -> Bool {
        let feedback = messaging.deleteMessages(auth!, convoId: convoId)
        return (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2
    }
    
    
//    func postMessage(msgId: String, text: String) -> (NSData?, NSURLResponse?, NSError?) {
//        return messaging.modifyMessage(auth!, msgId: msgId, text: text)
//    }
    func postMessage(msgId: String, text: String) -> Bool {
        let feedback = messaging.modifyMessage(auth!, msgId: msgId, text: text)
        return (feedback.1 as! NSHTTPURLResponse).statusCode / 100 == 2
    }
    
    func getAttachment(msgId: String, attachId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return messaging.getAttachment(auth!, msgId: msgId, attachId: attachId)
    }
    
    
    // Presence Methods
    func getPresence() -> (NSData?, NSURLResponse?, NSError?) {
        return presence.getPresence(auth!)
    }
    
    
    // Account Methods
    func getAccountId() -> (NSData?, NSURLResponse?, NSError?) {
        return account.getAccountId(auth!)
    }
    
    func getAccountIdExtensionId() -> (NSData?, NSURLResponse?, NSError?) {
        return account.getAccountIdExtensionId(auth!)
    }
    
    func getExtensions() -> (NSData?, NSURLResponse?, NSError?) {
        return account.getExtensions(auth!)
    }
    
    
    // Dictionary Methods
    func getCountry(countryId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getCountry(auth!, countryId: countryId)
    }
    
    func getCountries() -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getCountries(auth!)
    }
    
    func getState(stateId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getState(auth!, stateId: stateId)
    }
    
    func getStates(countryId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getStates(auth!, countryId: countryId)
    }
    
    func getLocations(stateId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getLocations(auth!, stateId: stateId)
    }
    
    func getTimezone(zoneId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getTimezone(auth!, zoneId: zoneId)
    }
    
    func getTimezones() -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getTimezones(auth!)
    }
    
    func getLanguage(langId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getLanguage(auth!, langId: langId)
    }
    
    func getLanguages() -> (NSData?, NSURLResponse?, NSError?) {
        return dictionary.getLanguages(auth!)
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