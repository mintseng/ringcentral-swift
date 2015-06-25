import Foundation

class Messaging {
    let server: String
    
    init(server: String) {
        self.server = server
    }
    
    // Does not seem to work yet on exploerer API
    func getMessage(auth: Auth, msgId: String) -> (NSData, NSURLResponse, NSError) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/message-store/" + msgId)
        
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
        
//        println("1")
//        println((response as! NSHTTPURLResponse).statusCode)
//        println(response)
//        println(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        return (data!, response!, error!)
    }

    
    /// Gets back the messages stored for a specific account and extension
    ///
    ///
    func getMessages(auth: Auth) -> (NSData, NSURLResponse, NSError) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/message-store")
        
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
        
//        println("2")
//        println((response as! NSHTTPURLResponse).statusCode)
//        println(response)
//        println(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        return (data!, response!, error!)
    }
    
    func deleteMessage(auth: Auth, msgId: String) -> (NSData, NSURLResponse, NSError) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/message-store/" + msgId)
        
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
        
        return (data!, response!, error!)
    }
    
    func deleteMessages(auth: Auth, convoId: String) -> (NSData, NSURLResponse, NSError) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/message-store/" + convoId)
        
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
        
        return (data!, response!, error!)
    }
    
    /// Modifies a selected message
    ///
    /// **Caution**: Only updates 'Read' or 'Unread' status at the moment.
    /// This info goes inside of 'text'
    func modifyMessage(auth: Auth, msgId: String, text: String) -> (NSData, NSURLResponse, NSError) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/message-store/" + msgId)
        
        // Sets up the request
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer" + " " + auth.getAccessToken(), forHTTPHeaderField: "Authorization")
        
        let bodyString = "body=" + "{ \"readStatus\": \"" + text + "\"}"
        request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        var response: NSURLResponse?
        var error: NSError?
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        
        return (data!, response!, error!)
    }
    
    func getAttachment(auth: Auth, msgId: String, attachId: String) -> (NSData, NSURLResponse, NSError) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/message-store/" + msgId + "/content/" + attachId)
        
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
        
        return (data!, response!, error!)
    }
    
    /// Sends a fax to the given number
    ///
    /// Receiving an overhaul next RingCentral API update. Don't touch.
    func fax(auth: Auth, text: String, to: String) {
        
    }
    
    
    func sms(auth: Auth, text: String, to: String) -> (NSData?, NSURLResponse?, NSError?) {

        let url = NSURL(string: server + "/v1.0/account/~/extension/~/sms")
        
        let number: String = auth.getUsername()
        let bodyString = "{" +
            "\"to\": [{\"phoneNumber\": " +
            "\"" + to + "\"}]," +
            "\"from\": {\"phoneNumber\": \"" + number +
            "\"}," + "\"text\": \"" + text + "\"" + "}"
        
        let plainData = (auth.getAppKey() + ":" + auth.getAppSecret() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
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
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        
        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)

        
    }
    
    /// Sends a company pager
    ///
    /// Sends from extension to extension within the same number.
    func companyPager(auth: Auth, text: String, to: String...) -> (NSData?, NSURLResponse?, NSError?){
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/company-pager")
        
        let holder = auth.getExtension()
        
        var extensions: String = ""
        
        for (var i = 0; i < to.count; i++) {
            if (i != 0) {
                extensions = extensions + ","
            }
            "{\"extensionNumber\": \"" + to[i] + "\"}"
        }
        
        
        let number: String = auth.getUsername()
        let bodyString = "{" +
            "\"to\": [" + extensions + "]," +
            "\"from\": {\"extensionNumber\": \"" + holder + "\"}," +
            "\"text\": \"Hello!\"" +
            "}"
        
        let plainData = (auth.getAppKey() + ":" + auth.getAppSecret() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
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
        let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        
        var errors: NSError?
        let readdata = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
        
        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)

    }
    
}