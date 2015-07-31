import Foundation
import PubNub
import CryptoSwift

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
        let address: String
        let subscriperKey: String
        let secretKey: String
    }
    
    struct ISubscription {
        let eventFilters: [String]
        let expirationTime: String
        let expiresIn: NSNumber
        let deliveryMode: IDeliveryMode
        let id: String
        let creationTime: String
        let status: String
        let uri: String
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
    
    func renew(options: [String: AnyObject]) {
        
    }
    
    func subscribe(options: [String: AnyObject]) {
        
    }
    
    func isSubscribed() -> Bool {
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
        
    }
    
    private func subscribeAtPubnub() {
        
    }
    
    private func notify() {
        
    }
    
    
}