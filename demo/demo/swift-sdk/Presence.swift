import Foundation

class Presence {
    let server: String
    
    init(server: String) {
        self.server = server
    }
    
    func getPresence(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/account/~/extension/~/presence")
        
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
        
//        println(response)
//        println(NSString(data: data!, encoding: NSUTF8StringEncoding))
        
        return (data!, response!, error!)
    }
}