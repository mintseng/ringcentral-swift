import Foundation
import PubNub

class Subscription: NSObject, PNObjectEventListener {
    
    /// Fields of subscription
    private let platform: Platform!
    var pubnub: PubNub?
    private var eventFilters: [String] = []
    var subscription: ISubscription?
    var function: ((arg: String) -> Void) = {(arg) in }
    
    /// Initializes a subscription with Platform
    ///
    /// :param: platform        Authorized platform
    init(platform: Platform) {
        self.platform = platform
    }
    
    /// Structure holding information about how PubNub is delivered
    struct IDeliveryMode {
        var transportType: String = "PubNub"
        var encryption: Bool = false
        var address: String = ""
        var subscriberKey: String = ""
        var secretKey: String = ""
        var encryptionKey: String = ""
    }
    
    /// Structure holding information about the details of PubNub
    struct ISubscription {
        var eventFilters: [String] = []
        var expirationTime: String = ""
        var expiresIn: NSNumber = 0
        var deliveryMode: IDeliveryMode = IDeliveryMode()
        var id: String = ""
        var creationTime: String = ""
        var status: String = ""
        var uri: String = ""
    }
    
    /// Returns PubNub object
    ///
    /// :returns: PubNub object
    func getPubNub() -> PubNub? {
        return pubnub
    }
    
    /// Returns the platform
    ///
    /// :returns: Platform
    func getPlatform() -> Platform {
        return platform
    }
    
    /// Adds event for PubNub
    ///
    /// :param: events          List of events to add
    /// :returns: Subscription
    func addEvents(events: [String]) -> Subscription {
        for event in events {
            self.eventFilters.append(event)
        }
        return self
    }
    
    /// Sets events for PubNub (deletes all previous ones)
    ///
    /// :param: events          List of events to set
    /// :returns: Subscription
    func setevents(events: [String]) -> Subscription {
        self.eventFilters = events
        return self
    }
    
    /// Registers for a new subscription or renews an old one
    ///
    /// :param: options         List of options for PubNub
    func register(options: [String: AnyObject] = [String: AnyObject]()) {
        if (isSubscribed()) {
            return renew(options)
        } else {
            return subscribe(options)
        }
    }
    
    // getFullEventFilters()
    
    /// Renews the subscription
    ///
    /// :param: options         List of options for PubNub
    func renew(options: [String: AnyObject]) {
        if let events = options["eventFilters"] {
            self.eventFilters = events as! [String]
        } else if let events = options["events"] {
            self.eventFilters = events as! [String]
        } else {
            self.eventFilters = [
                "/restapi/v1.0/account/~/extension/~/presence",
                "/restapi/v1.0/account/~/extension/~/message-store"
            ]
        }
        
        platform.apiCall([
            "method": "PUT",
            "url": "restapi/v1.0/subscription/" + subscription!.id,
            "body": [
                "eventFilters": getFullEventFilters()
            ]
        ]) {
            (data, response, error) in
            let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
            if let error = dictionary["errorCode"] {
                self.subscribe(options)
            } else {
                self.subscription!.expiresIn = dictionary["expiresIn"] as! NSNumber
                self.subscription!.expirationTime = dictionary["expirationTime"] as! String
            }
        }
    }
    
    /// Subscribes to a channel with given events
    ///
    /// :param: options         Options for PubNub
    func subscribe(options: [String: AnyObject]) {
        if let events = options["eventFilters"] {
            self.eventFilters = events as! [String]
        } else if let events = options["events"] {
            self.eventFilters = events as! [String]
        } else {
            self.eventFilters = [
                "/restapi/v1.0/account/~/extension/~/presence",
                "/restapi/v1.0/account/~/extension/~/message-store"
            ]
        }
        
        platform.apiCall([
            "method": "POST",
            "url": "/restapi/v1.0/subscription",
            "body": [
                "eventFilters": getFullEventFilters(),
                "deliveryMode": [
                    "transportType": "PubNub",
                    "encryption": "false"
                ]
            ]
            ]) {
                (data, response, error) in
                
                let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
                var sub = ISubscription()
                sub.eventFilters =      dictionary["eventFilters"] as! [String]
                self.eventFilters =     dictionary["eventFilters"] as! [String]
                sub.expirationTime =    dictionary["expirationTime"] as! String
                sub.expiresIn =         dictionary["expiresIn"] as! NSNumber
                sub.id =                dictionary["id"] as! String
                sub.creationTime =      dictionary["creationTime"] as! String
                sub.status =            dictionary["status"] as! String
                sub.uri =               dictionary["uri"] as! String
                self.subscription = sub
                var del = IDeliveryMode()
                var dictDelivery =      dictionary["deliveryMode"] as! NSDictionary
                del.transportType =     dictDelivery["transportType"] as! String
                del.encryption =        dictDelivery["encryption"] as! Bool
                del.address =           dictDelivery["address"] as! String
                del.subscriberKey =     dictDelivery["subscriberKey"] as! String
                del.secretKey =         dictDelivery["secretKey"] as! String
                del.encryptionKey =     dictDelivery["encryptionKey"] as! String
                self.subscription!.deliveryMode = del
                self.subscribeAtPubnub()
        }
    }
    
    /// Unsubscribes from the current subscription
    func destroy() {
        if let sub = self.subscription {
            unsubscribe()
        }
    }
    
    /// Sets a method that will run after every PubNub callback
    ///
    /// :param: functionHolder      Function to be ran after every PubNub callback
    func setMethod(functionHolder: ((arg: String) -> Void)) {
        self.function = functionHolder
    }
    
    /// Checks if currently subscribed
    ///
    /// :returns: Bool of if currently subscribed
    func isSubscribed() -> Bool {
        if let sub = self.subscription {
            let dil = sub.deliveryMode
            return dil.subscriberKey != "" && dil.address != ""
        }
        return false
    }
    
    /// Emits events
    func emit(event: String) -> AnyObject {
        return ""
    }
    
    /// Returns all the event filters
    ///
    /// :returns: [String] of all the event filters
    private func getFullEventFilters() -> [String] {
        return eventFilters
    }
    
    /// Updates the subscription with the one passed in
    ///
    /// :param: subscription        New subscription passed in
    private func updateSubscription(subscription: ISubscription) {
        self.subscription = subscription
    }
    
    /// Unsubscribes from subscription
    private func unsubscribe() {
        if let channel = subscription?.deliveryMode.address {
            pubnub?.unsubscribeFromChannelGroups([channel], withPresence: true)
        }
        self.subscription = nil
        self.eventFilters = []
        self.pubnub = nil
        
        if let sub = subscription {
            platform.apiCall([
                "method": "DELETE",
                "url": "/restapi/v1.0/subscription/" + sub.id,
                "body": [
                    "eventFilters": getFullEventFilters(),
                    "deliveryMode": [
                        "transportType": "PubNub",
                        "encryption": "false"
                    ]
                ]
                ])
        }
    }
    
    /// Subscribes to a channel given the settings
    private func subscribeAtPubnub() {
        let config = PNConfiguration( publishKey: "", subscribeKey: subscription!.deliveryMode.subscriberKey)
        self.pubnub = PubNub.clientWithConfiguration(config)
        self.pubnub?.addListener(self)
        self.pubnub?.subscribeToChannels([subscription!.deliveryMode.address], withPresence: true)
    }
    
    /// Notifies
    private func notify() {
        
    }
    
    /// Method that PubNub calls when receiving a message back from Subscription
    ///
    /// :param: client          The client of the receiver
    /// :param: message         Message being received back
    func client(client: PubNub!, didReceiveMessage message: PNMessageResult!) {
        var base64Message = message.data.message as! String
        var base64Key = self.subscription!.deliveryMode.encryptionKey
        
        let key = [0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00] as [UInt8]
        let iv = Cipher.randomIV(AES.blockSize)
        let decrypted = AES(key: base64ToByteArray(base64Key), iv: [0x00], blockMode: .ECB)?.decrypt(base64ToByteArray(base64Message), padding: PKCS7())
        
        var endMarker = NSData(bytes: (decrypted as [UInt8]!), length: decrypted!.count)
        if let str: String = NSString(data: endMarker, encoding: NSUTF8StringEncoding) as? String  {
            self.function(arg: str)
        } else {
            println("error")
        }
    }
    
    /// Converts base64 to byte array
    ///
    /// :param: base64String        base64 String to be converted
    /// :returns: [UInt8] byte array
    private func base64ToByteArray(base64String: String) -> [UInt8] {
        let nsdata: NSData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0))!
        var bytes = [UInt8](count: nsdata.length, repeatedValue: 0)
        nsdata.getBytes(&bytes)
        return bytes
    }
    
    /// Converts byte array to base64
    ///
    /// :param: bytes               byte array to be converted
    /// :returns: String of the base64
    private func byteArrayToBase64(bytes: [UInt8]) -> String {
        let nsdata = NSData(bytes: bytes, length: bytes.count)
        let base64Encoded = nsdata.base64EncodedStringWithOptions(nil);
        return base64Encoded;
    }
    
    /// Converts a dictionary represented as a String into a NSDictionary
    ///
    /// :param: string              Dictionary represented as a String
    /// :returns: NSDictionary of the String representation of a Dictionary
    private func stringToDict(string: String) -> NSDictionary {
        var data: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        return NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
    }
}









