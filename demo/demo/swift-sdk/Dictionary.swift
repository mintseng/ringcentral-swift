import Foundation

class Dictionary {
    
    let server: String
    
    init(server: String) {
        self.server = server
    }
    
    func getCountry(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        return getCountry(auth, countryId: "1")
    }
    
    func getCountry(auth: Auth, countryId: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/country/" + countryId)
        
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
        
        return (data, response, error)
    }
    
    func getCountries(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/country/")
        
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
//        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)
    }
    
    func getState(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        return getState(auth, stateId: "13")
    }
    
    func getState(auth: Auth, stateId: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/state/" + stateId)
        
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
        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)
    }
    
    func getStates(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        return getStates(auth, countryId: "1")
    }
    
    func getStates(auth: Auth, countryId: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/state?countryId=" + countryId)
        
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
        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)
    }
    
    func getLocations(auth: Auth, stateId: String) -> (NSData?, NSURLResponse?, NSError?) {
        return getLocations(auth, stateId: stateId, orderBy: "City")
    }
    
    func getLocations(auth: Auth, stateId: String, orderBy: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/location?stateId=" + stateId + "&orderBy=" + orderBy)
        
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
        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data!, response!, error!)
    }
    
    func getTimezone(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        return getTimezone(auth, zoneId: "1")
    }
    
    func getTimezone(auth: Auth, zoneId: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/timezone/" + zoneId)
        
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
        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)
    }
    
    func getTimezones(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/timezone")
        
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
        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)
    }
    
    func getLanguage(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        return getLanguage(auth, langId: "1033")
    }
    
    func getLanguage(auth: Auth, langId: String) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/language/" + langId)
        
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
        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)
    }
    
    func getLanguages(auth: Auth) -> (NSData?, NSURLResponse?, NSError?) {
        let url = NSURL(string: server + "/v1.0/dictionary/language")
        
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
        
//        println((response as! NSHTTPURLResponse).statusCode)
        
        return (data, response, error)
    }
    
}