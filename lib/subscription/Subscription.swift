import Foundation
import PubNub

class Subscription {
    
    private let platform: Platform!
    private var pubnub: PubNub?
    private var eventFilters: [String] = []
    private var subscription: ISubscription?
    
    init(platform: Platform) {
        self.platform = platform
        
    }
    
    struct IDeliveryMode {
        var transportType: String = "PubNub"
        var encryption: Bool = false
        var address: String = ""
        var subscriberKey: String = ""
        var secretKey: String = ""
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

    func register(options: [String: AnyObject]) {
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
        } else {
            self.eventFilters = [
                "/restapi/v1.0/account/~/extension/~/presence",
                "/restapi/v1.0/account/~/extension/~/message-store"
            ]
        }
    }
    
    func subscribe(options: [String: AnyObject]) {
        if let events = options["eventFilters"] {
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
                self.subscription = sub
                sub.eventFilters =      dictionary["eventFilters"] as! [String]
                sub.expirationTime =    dictionary["expirationTime"] as! String
                sub.expiresIn =         dictionary["expiresIn"] as! NSNumber
                sub.id =                dictionary["id"] as! String
                sub.creationTime =      dictionary["creationTime"] as! String
                sub.status =            dictionary["status"] as! String
                sub.uri =               dictionary["uri"] as! String
                
                var del = sub.deliveryMode
                var dictDelivery =      dictionary["deliveryMode"] as! NSDictionary
                del.transportType =     dictDelivery["transportType"] as! String
                del.encryption =        dictDelivery["encryption"] as! Bool
                del.address =           dictDelivery["address"] as! String
                del.subscriberKey =     dictDelivery["subscriberKey"] as! String
                del.secretKey =         dictDelivery["secretKey"] as! String    
                
        }
        
    }
    
    func destroy() {
        if let sub = self.subscription {
            unsubscribe()
        }
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
    }
    
    private func subscribeAtPubnub() {
        
    }
    
    private func notify() {
        
    }
    
    
}