import Foundation

class Response: Headers {
    
    /// Response fields
    var status: Int!
    var statusText: String!
    var body: String?
    
    var data: NSData?
    var response: NSURLResponse?
    var error: NSError?
    
    /// Initializes HTTP response object
    ///
    /// :param: data            content of the response
    /// :param: response        status code
    /// :param: error           error, nil if no error
    init(data: NSData?, response: NSURLResponse, error: NSError?) {
        if let check = error {
            super.init()
        } else {
            let feedback = (response as! NSHTTPURLResponse)
            super.init(options: feedback.allHeaderFields)
            status = feedback.statusCode
        }
        statusText = ""
        if let check = data {
            body = NSString(data: check, encoding: NSUTF8StringEncoding)! as String
        }
    }
    
    /// Checks if status is successful
    ///
    /// :returns: Bool of successful status
    func checkStatus() -> Bool {
        return status >= 200 && status < 300
    }
    
    /// Returns the body
    ///
    /// :returns: String of body of response object
    func getBody() -> String? {
        return body
    }
    
    /// Returns the body
    ///
    /// :returns: String of body of response object
    func getResponse() -> NSURLResponse? {
        return response
    }
    
    /// Returns the data
    ///
    /// :returns: String of data of response object
    func getData() -> NSData? {
        return data
    }
    
    /// Returns the data (in String)
    ///
    /// :returns: String of data of response object
    func getData() -> String? {
        return body
    }
    
    //    func getJson()
    
    //    func getResponses()
    
    /// Returns the status of the HTTP response
    ///
    /// :returns: Int of HTTP response status
    func getStatus() -> Int {
        return status
    }
    
    /// Returns the status text
    ///
    /// :returns: String of text of status
    func getStatusText() -> String {
        return statusText
    }
    
    /// Returns the error as String
    ///
    /// :returns: String of error
    func getError() -> String {
        if let x = error {
            return x.description
        } else {
            return ""
        }
    }
    
    /// Returns the error as NSError
    ///
    /// :returns: NSError of error
    func getError() -> NSError? {
        return error
    }
    
}