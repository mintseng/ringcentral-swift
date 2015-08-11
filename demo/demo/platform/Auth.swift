import Foundation

/// Authorization object for the platform.
class Auth {
    
    static let MAINCOMPANY = "101"
    
    // Authorization information
    var access_token: String?
    var expires_in: Double = 0
    var expire_time: Double = 0
    
    var app_key: String?
    var app_secret: String?
    
    var refresh_token: String?
    var refresh_token_expires_in: Double = 0
    var refresh_token_expire_time: Double = 0
    
    var token_type: String?
    var scope: String?
    var owner_id: String?
    
    let username: String
    let password: String
    let ext: String
    let server: String
    
    var authenticated: Bool = false
    
    /// Constructor for authorization for the platform
    ///
    /// :param: username RingCentral phone number
    /// :param: password Password to the RingCentral account
    convenience init(username: String, password: String, server: String) {
        self.init(username: username, ext: Auth.MAINCOMPANY, password: password, server: server)
    }
    
    
    /// Constructor for authorization for the platform with extension
    ///
    /// :param: username RingCentral phone number
    /// :param: password Password to the RingCentral account
    init(username: String, ext: String, password: String, server: String) {
        self.server = server
        self.username = username
        self.password = password
        self.ext = ext
    }
    
    // PROBLEM: cannot get "scope" to work as inteded according to API
    //          does not work on API explorer either
    
    /// Logs the user in with the current credentials.
    ///
    /// :param: key The appKey for RC account
    /// :param: secret The appSecret for RC account
    func login(key: String, secret: String) -> (NSData?, NSURLResponse?, NSError?) {
        self.app_key = key
        self.app_secret = secret
        
        // URL api call for getting token
        let url = NSURL(string: server + "/restapi/oauth/token")
        
        // Setting up User info for parsing
        let bodyString = "grant_type=password&" + "username=" + self.username + "&" + "password=" + self.password + "&" + "extension=" + self.ext
        let plainData = (key + ":" + secret as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        // Setting up HTTP request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic" + " " + base64String, forHTTPHeaderField: "Authorization")
        
        // Sending HTTP request
        var response: NSURLResponse?
        var error: NSError?
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        if (response as! NSHTTPURLResponse).statusCode / 100 != 2 {
            return (data, response, error)
        }
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        
        
        
        
        // Setting authentication information
        self.authenticated = true
        self.access_token = readdata["access_token"] as? String
        self.expires_in = readdata["expires_in"] as! Double
        
        self.refresh_token = readdata["refresh_token"] as? String
        self.refresh_token_expires_in = readdata["refresh_token_expires_in"] as! Double
        
        self.token_type = readdata["token_type"] as? String
        self.scope = readdata["scope"] as? String
        self.owner_id = readdata["owner_id"] as? String
        
        let time = NSDate().timeIntervalSince1970
        
        self.expire_time = time + self.expires_in
        self.refresh_token_expire_time = time + self.refresh_token_expires_in
        
        return (data, response, error)
        
    }
    
    /// Refreshes the access_token and refresh_token with the current refresh_token
    ///
    ///
    func refresh() -> (NSData?, NSURLResponse?, NSError?) {
        // URL api call for getting token
        let url = NSURL(string: server + "/oauth/token")
        
        // Setting up User info for parsing
        var bodyString = "grant_type=refresh_token&" + "username=" + self.username + "&" + "password=" + self.password + "&" + "extension=" + self.ext + "&" + "refresh_token=" + self.refresh_token!
        let plainData = (self.app_key! + ":" + self.app_secret! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        // Setting up HTTP request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic" + " " + base64String, forHTTPHeaderField: "Authorization")
        
        // Sending HTTP request
        
        var response: NSURLResponse?
        var error: NSError?
        let data: NSData! = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errors) as! NSDictionary
        
        
        // Setting authentication information
        self.authenticated = true
        self.access_token = readdata["access_token"] as? String
        self.expires_in = readdata["expires_in"] as! Double
        
        self.refresh_token = readdata["refresh_token"] as? String
        self.refresh_token_expires_in = readdata["refresh_token_expires_in"] as! Double
        
        self.token_type = readdata["token_type"] as? String
        self.scope = readdata["scope"] as? String
        self.owner_id = readdata["owner_id"] as? String
        
        let time = NSDate().timeIntervalSince1970
        
        self.expire_time = time + self.expires_in
        self.refresh_token_expire_time = time + self.refresh_token_expires_in
        
        
        return (data, response, error)
        
    }
    
    /// Checks whether or not the access token is valid
    ///
    /// :returns: A boolean for validity of access token
    func isAccessTokenValid() -> Bool {
        return false
    }
    
    /// Checks for the validity of the refresh token
    ///
    /// :returns: A boolean for validity of the refresh token
    func isRefreshTokenVald() -> Bool {
        return false
    }
    
    /// Revokes the access_token
    ///
    ///
    func revokeToken() -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/oauth/revoke")
        
        
        // Setting up User info for parsing
        let bodyString = "token=" + access_token!
        let plainData = (app_key! + ":" + app_secret! as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        // Setting up request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic" + " " + base64String, forHTTPHeaderField: "Authorization")
        
        var response: NSURLResponse?
        var error: NSError?
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        self.access_token = nil
        self.expires_in = 0
        self.expire_time = 0
        
        self.refresh_token = nil
        self.refresh_token_expires_in = 0
        self.refresh_token_expire_time = 0

        
        return (data, response, error)
        
    }
    
    func getAccessToken() -> String {
        return self.access_token!
    }
    
    func getRefreshToken() -> String {
        return self.refresh_token!
    }
    
    func getUsername() -> String {
        return self.username
    }
    
    func getAppKey() -> String {
        return self.app_key!
    }
    
    func getAppSecret() -> String {
        return self.app_secret!
    }
    
    func getExtension() -> String {
        return self.ext
    }
    
}