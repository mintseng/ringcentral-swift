import Foundation
import PubNub

class Subscription: NSObject, PNObjectEventListener {
    
    private let platform: Platform!
    var pubnub: PubNub?
    private var eventFilters: [String] = []
    var subscription: ISubscription?
    var function: ((arg: String) -> Void) = {(arg) in }
    
    init(platform: Platform) {
        self.platform = platform
        
    }
    
    struct IDeliveryMode {
        var transportType: String = "PubNub"
        var encryption: Bool = false
        var address: String = ""
        var subscriberKey: String = ""
        var secretKey: String = ""
        var encryptionKey: String = ""
    }
    
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
    
    func getPubNub() -> PubNub? {
        return pubnub
    }
    
    func getPlatform() -> Platform {
        return platform
    }
    
    func addEvents(events: [String]) -> Subscription {
        for event in events {
            self.eventFilters.append(event)
        }
        return self
    }
    
    func setevents(events: [String]) -> Subscription {
        self.eventFilters = events
        return self
    }

    func register(options: [String: AnyObject] = [String: AnyObject]()) {
        if (isSubscribed()) {
            return renew(options)
        } else {
            return subscribe(options)
        }
    }
    
    // getFullEventFilters()
    
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
    
    func destroy() {
        if let sub = self.subscription {
            unsubscribe()
        }
    }
    
    func setMethod(functionHolder: ((arg: String) -> Void)) {
        self.function = functionHolder
    }
    
    func isSubscribed() -> Bool {
        if let sub = self.subscription {
            let dil = sub.deliveryMode
            return dil.subscriberKey != "" && dil.address != ""
        }
        return false
    }
    
    func on(event: String, callback: (args: AnyObject...) -> ()) -> Subscription {
        return Subscription(platform: platform)
    }
    
    func off(event: String, callback: (args: AnyObject...) -> ()) -> Subscription {
        return Subscription(platform: platform)
    }
    
    func emit(event: String) -> AnyObject {
        return ""
    }
    
    private func getFullEventFilters() -> [String] {
        return eventFilters
    }
    
    private func updateSubscription(subscription: ISubscription) {
        self.subscription = subscription
    }
    
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
    
    private func subscribeAtPubnub() {
        let config = PNConfiguration( publishKey: "", subscribeKey: subscription!.deliveryMode.subscriberKey)
        self.pubnub = PubNub.clientWithConfiguration(config)
        self.pubnub?.addListener(self)
        self.pubnub?.subscribeToChannels([subscription!.deliveryMode.address], withPresence: true)
    }
    
    private func notify() {
        
    }
    
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
    
    private func base64ToByteArray(base64String: String) -> [UInt8] {
        let nsdata: NSData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions(rawValue: 0))!
        var bytes = [UInt8](count: nsdata.length, repeatedValue: 0)
        nsdata.getBytes(&bytes)
        return bytes
    }
    
    private func byteArrayToBase64(bytes: [UInt8]) -> String {
        let nsdata = NSData(bytes: bytes, length: bytes.count)
        let base64Encoded = nsdata.base64EncodedStringWithOptions(nil);
        return base64Encoded;
    }
    
    private func stringToDict(string: String) -> NSDictionary {
        var data: NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        return NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
    }
}









