import Foundation

/// Object representation of a Standard Development Kit for RingCentral
class Sdk {
    
    
    // Set constants for SANDBOX and PRODUCTION servers.
    static var RC_SERVER_PRODUCTION: String = "https://platform.ringcentral.com/restapi"
    static var RC_SERVER_SANDBOX: String = "https://platform.devtest.ringcentral.com/restapi"
    
    // Platform variable, version, and current Subscriptions
    var platform: Platform
    var subscription: Subscription?
    
    let server: String
    
    /// Constructor for making the SDK object.
    ///
    /// Example:
    ///
    ///     init(appKey, appSecret, Sdk.RC_SERVER_PRODUCTION)
    /// or
    ///
    ///     init(appKey, appSecret, Sdk.RC_SERVER_SANDBOX)
    /// 
    /// :param: appKey      The appKey of your app
    /// :param: appSecet    The appSecret of your app
    /// :param: server      Choice of PRODUCTION or SANDBOX
    init(appKey: String, appSecret: String, server: String) {
        platform = Platform(appKey: appKey, appSecret: appSecret, server: server)
        self.server = server
        setVersion()
    }
    
    
    /// Sets version to the version of the current SDK
    func setVersion() {
        let url = NSURL(string: server + "/")
        
        // Sets up the request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        
        // Sending HTTP request
        var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            (data, response, error) in
            if error != nil {
                println(error)
            } else {
                if ((response as! NSHTTPURLResponse).statusCode / 100 != 2) {
                    println(response)
                    println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    return
                }
                
                var errors: NSError?
                let readdata = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errors) as! NSDictionary
                                
            }
            
            
        }
        
        task.resume()
    }
    
    /// Returns the Platform with the specified appKey and appSecret.
    ///
    /// :returns: A Platform to access the methods of the SDK
    func getPlatform() -> Platform {
        return self.platform
    }
    
    /// Returns the current Subscription.
    ///
    /// :returns: A Subscription that the user is currently following
    func getSubscription() -> Subscription? {
        return self.subscription
    }
    
    
    
}