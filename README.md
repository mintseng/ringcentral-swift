RingCentral Swift SDK
=====================

***

1. [Overview](#overview)
2. [Setting Up](#setting-up)
3. [Initialization](#initialization)
4. [Authorization](#authorization)
5. [Generic Requests](#generic-requests)
6. [Performing RingOut](#ring-out)
7. [Sending SMS](#sending-sms)
    1. [Account](#account)
    2. [Call Log](#call-log)
    3. [Presence](#presence)
    4. [Messaging](#messaging)
    5. [Dictionary](#dictionary)
    6. [Subscription](#subscription)
8. [SDK Demos](#sdk-demos)


***

# Overview

The purpose of this RingCentral Swift SDK is to assist other developers in expediating the
development of any application. This is currently NOT the official SDK for RingCentral,
and is still an ongoing project. The outlines attempt to mirror the legacy of other SDks,
however it is not guaranteed to be exactly the same.

Currently this SDK supports most functionalities, with the exception of:
    - Faxing
    - PubNub subscription (an alternative will be implemented)
    - Various indepth options that are currently not supported by RingCentral API

***

# Setting Up

# Initialization

The RingCentral SDK is initiated in the following ways.

Sandbox:
```swift
var rcsdk = Sdk(appKey: app_key, appSecret: app_secret, server: Sdk.RC_SERVER_SANDBOX)
```

Production:
```swift
var rcsdk = Sdk(appKey: app_key, appSecret: app_secret, server: Sdk.RC_SERVER_PRODUCTION)
```

Depending on the stage of production, either Sdk.RC_SERVER_SANDBOX or Sdk.RC_SERVER_PRODUCTION
will be used as the 'server' parameter.

# Authorization

To authorize the platform, extract the 'Platform' object:

```swift
var platform = rcsdk.getPlatform()
```

Once the platform is extracted, call:

```swift
platform.authorize(username, password: password)
```
or (to authorize with extension):
```swift
platform.authorize(username, ext: ext, password: password)
```
*Caution*: If no extension is specified, platform automitically refers extension 101 (default).
***

# Generic Requests

Currently, all method calls support a standard (DATA, RESPONSE, ERROR) return protocal.
A parsing class will be provided to use at your disposal, however the functionality of
what it returns is limited (based on what developers will likely need most).

Most method calls will follow this behavior:
```swift
var feedback = platform.methodCall(auth!)
// feedback.0 -> data
// feedback.1 -> response
// feedback.2 -> error

```


Rule of thumb: Always check if 'error' is nil
```swift
if (let x = feedback.2) {
    // Handle the error
} else {
    // Continue doing whatever
}
```

For simple checking of a successful status code:
```swift
(response as! NSHTTPURLResponse).statusCode / 100 == 2
```

For turning 'data' into a Dictionary (JSON):
```swift
NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
or 
NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary
```

For readability of the data
```swift
println(NSString(data: data!, encoding: NSUTF8StringEncoding))
```
*Usability*: Method calls for RingOut or SMS (anything that you dont need information back from)
can be directly called without setting the 'feedback' to a variable.

# Performing RingOut

RingOut follows a two-legged style telecommunication protocol.

The following method call is used to send a Ring Out.
If successful it will return true, if not it will return false.
```swift
postRingOut(from: "14088861168", to: "1408861168") // true
```

The following method call is used to obtain the status of a Ring Out.
Returns the generic (data, response, error) return type specified above.
```swift
getRingOut(ringId: "14088861168", to: "14088861168")
```

The following method call is used to delete a ring out object.
Returns true if successful, false if not.
```swift
deleteRingOut(ringId: "1408861168") // true
```

# Sending SMS

***

## Account

## Call Log

## Presence

## Messaging

## Dictionary

## Subscription

***

# SDK Demos