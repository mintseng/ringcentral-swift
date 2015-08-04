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
        let transportType: String = "PubNub"
        let encryption: Bool = false
        let address: String = ""
        let subscriberKey: String = ""
        let secretKey: String = ""
    }
    
    struct ISubscription {
        let eventFilters: [String] = []
        let expirationTime: String = ""
        let expiresIn: NSNumber = 0
        let deliveryMode: IDeliveryMode = IDeliveryMode()
        let id: String = ""
        let creationTime: String = ""
        let status: String = ""
        let uri: String = ""
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
        
    }
    
    func subscribe(options: [String: AnyObject]) {
        if let events = options["eventFilters"] {
            self.eventFilters = events as! [String]
        }
        
        platform.apiCall([
            "method": "POST",
            "url": platform.server + "/restapi/v1.0/subscription",
            
        ])
        
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