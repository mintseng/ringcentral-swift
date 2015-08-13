import Foundation

class Headers {
    
    /// Field for types
    var contentType = "Content-Type"
    var jsonContentType = "application/json"
    var multipartContentType = "multipart/mixed"
    var urlencodedContentType = "application/x-www-form-urlencoded"
    var utf8ContentType = "charset=UTF-8"
    
    var headers: [String: String] = [String:String]()
    
    /// Initializes a HTTP header with default 'Content-Type' and 'Accept' values
    init() {
        headers["Content-Type"] = urlencodedContentType
        headers["Accept"] = jsonContentType
    }
    
    /// Initializes a HTTP header with options based on the passed in Dictionary
    init(options: [NSObject: AnyObject]) {
        for key in (options as! [String: String]).keys {
            headers[key] = options[key] as? String
        }
    }
    
    /// Gets a header value
    ///
    /// :param: name        Name for header
    /// :returns: String for the value of the header
    func getHeader(name: String) -> String! {
        if hasHeader(name) {
            return headers[name]
        } else {
            return ""
        }
    }
    
    /// Gets all the header values
    ///
    /// :returns: [String: String] of all the headers
    func getHeaders() -> [String: String]! {
        return headers
    }
    
    /// Checks if header exists
    ///
    /// :param: name        Name of the header being checked
    /// :returns: Bool of whether or not header exists
    func hasHeader(name: String) -> Bool {
        if let x = headers[name] {
            return true
        } else {
            return false
        }
    }
    
    /// Sets a header with a value
    ///
    /// :param: name        Name of the header
    /// :param: value       Value of the header
    func setHeader(name: String!, value: String!) {
        headers[name] = value
    }
    
    /// Sets a whole dictionary of header values
    ///
    /// :param: headers     List of header and value pairs
    func setHeaders(headers: [String: String]) {
        for name in headers.keys {
            setHeader(name, value: headers[name])
        }
    }
    
    /// Checks if header is a certain content type
    ///
    /// :returns: Bool of whether or not header is a certain content type
    func isContentType(type: String) -> Bool {
        for value in getContentType().componentsSeparatedByString(";") {
            if value == type {
                return true
            }
        }
        return false
    }
    
    /// Gets the content type of the header
    ///
    /// :returns: String of content type
    func getContentType() -> String! {
        if let x = headers["Content-Type"] {
            return x
        } else {
            return ""
        }
    }
    
    /// Checks if header is multi-part
    ///
    /// :returns: Bool of whether or not header is multi-part
    func isMultipart() -> Bool {
        return isContentType(multipartContentType)
    }
    
    /// Checks if header is url-encoded
    ///
    /// :returns: Bool of whether or not header is url-encoded
    func isUrlEncoded() -> Bool {
        return isContentType(urlencodedContentType)
    }
    
    /// Checks if header is json
    ///
    /// :returns: Bool of whether or not header is json
    func isJson() -> Bool {
        return isContentType(jsonContentType)
    }
}