import Foundation

class Subscription {
    
    private let platform: Platform
    private var pubnub: PubNub?
    private var eventFilters: [String]
    private var subscription: ISubscription
    
    
    init(platform: Platform) {
        
    }
    
    struct IDeliveryMode {
        let transportType: String
        let encryption: Bool
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
        
    }
    
    func setevents(events: [String]) -> Subscription {
        
    }
    
    func register(options: [String: AnyObject]) {
        
    }
    
    func renew(options: [String: AnyObject]) {
        
    }
    
    func isSubscribed() -> Bool {
        
    }
    
    func on(event: String, callback: (args: AnyObject...) -> ()) -> Subscription {
        
    }
    
    func off(event: String, callback: (args: AnyObject...) -> ()) -> Subscription {
        
    }
    
    func emit(event: String) -> AnyObject {
        
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