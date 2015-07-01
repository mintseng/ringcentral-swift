import Foundation

class RingOut {
    let server: String
    
    init(server: String) {
        self.server = server
    }
    
    func ringOut(auth: Auth, from: String, to: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/ringout")
        let number: String = auth.getUsername()
        
        // Setting up User info for parsing
        let bodyString = "{" +
            "\"to\": {\"phoneNumber\": \"" +
            to +
            "\"}," +
            "\"from\": {\"phoneNumber\": \"" +
            from +
            "\"}," +
            "\"callerId\": {\"phoneNumber\": \"" +
            auth.getUsername() +
            "\"}," +
            "\"playPrompt\": true" +
        "}"
        
        let plainData = (auth.getAppKey() + ":" + auth.getAppKey() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        // Setting up request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Accept")
        request.setValue("Bearer" + " " + auth.getAccessToken(), forHTTPHeaderField: "Authorization")
        
        var response: NSURLResponse?
        var error: NSError?
        let data: NSData! = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        return (data, response, error)
        
    }
    
    
    /// Honestly no idea what this does
    ///
    /// DOES NOT SEEM TO WORK: "message" : "object not found"
    func getRingOut(auth: Auth, ringId: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/ringout/" + ringId)
        
        // Sets up the request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer" + " " + auth.getAccessToken(), forHTTPHeaderField: "Authorization")
        
        var response: NSURLResponse?
        var error: NSError?
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        
        println(response)
        println(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        return (data, response, error)
    }
    
    /// Deletes a ringOut
    ///
    /// Can only be done if the CALLEE has not yet accepted the call
    func deleteRingOut(auth: Auth, ringId: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/ringout/" + ringId)
        
        // Sets up the request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer" + " " + auth.getAccessToken(), forHTTPHeaderField: "Authorization")
        
        var response: NSURLResponse?
        var error: NSError?
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        
        return (data, response, error)
    }
}