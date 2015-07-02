RingCentral Swift SDK
=====================


***

1. [Overview](#overview)
2. [Setting Up](#setting-up)
3. [Initialization](#initialization)
4. [Authorization](#authorization)
5. [Generic Requests](#generic-requests)
6. [Performing RingOut](#performing-ringout)
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

**Sandbox:**
<!-- language: swift -->
    var rcsdk = Sdk(appKey: app_key, appSecret: app_secret, server: Sdk.RC_SERVER_SANDBOX)

**Production:**
<!-- language: swift -->
    var rcsdk = Sdk(appKey: app_key, appSecret: app_secret, server: Sdk.RC_SERVER_PRODUCTION)


Depending on the stage of production, either                                        
**Sdk.RC_SERVER_SANDBOX** or **Sdk.RC_SERVER_PRODUCTION**                                   
will be used as the 'server' parameter.

# Authorization

To authorize the platform, extract the 'Platform' object:

<!-- language: swift -->
    var platform = rcsdk.getPlatform()


Once the platform is extracted, call:

<!-- language: swift -->
    platform.authorize(username, password: password)

or (to authorize with extension):
<!-- language: swift -->
    platform.authorize(username, ext: ext, password: password)

*Caution*: If no extension is specified, platform automitically refers extension 101 (default).
***

# Generic Requests

Currently, all method calls support a standard (DATA, RESPONSE, ERROR) return protocal.
A parsing class will be provided to use at your disposal, however the functionality of
what it returns is limited (based on what developers will likely need most).

**Most method calls will follow this behavior:**
<!-- language: swift -->
    var feedback = platform.methodCall(auth!)
    // feedback.0 -> data
    // feedback.1 -> response
    // feedback.2 -> error




Rule of thumb: Always check if 'error' is nil
<!-- language: swift -->
    if (let x = feedback.2) {
        // Handle the error
    } else {
        // Continue doing whatever
    }


For simple checking of a successful status code:
<!-- language: swift -->
    (response as! NSHTTPURLResponse).statusCode / 100 == 2


For turning 'data' into a Dictionary (JSON):
<!-- language: swift -->
    NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &errors) as! NSDictionary
    
    // or

    NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary


For readability of the data
<!-- language: swift -->
    println(NSString(data: data!, encoding: NSUTF8StringEncoding))

*Usability*: Method calls for RingOut or SMS (anything that you dont need information back from)
can be directly called without setting the 'feedback' to a variable.

# Performing RingOut

RingOut follows a two-legged style telecommunication protocol.                  
                                                                                
The following method call is used to send a Ring Out.                           
If successful it will return true, if not it will return false.
<!-- language: swift -->
    platform.postRingOut(from: "12345678912", to: "12345678912") // true


**Additional Features**:
                                                                                
The following method call is used to obtain the status of a Ring Out.           
Returns the generic (data, response, error) return type specified above.        
<!-- language: swift -->
    platform.getRingOut(ringId: "12345678912", to: "12345678912")

                                                                                
The following method call is used to delete a ring out object.
Returns true if successful, false if not.
The parameter given is the "ringId" of the Ring Out object.
<!-- language: swift -->
    platform.deleteRingOut("123") // true


# Sending SMS

The follow method call is used to send a SMS.
If successful it will return true, false if not.
<!-- language: swift -->
    platform.postSms("hi i'm min", to: "12345678912") // true


**Additional Features**:

The following call is used to obtain a message that was sent.
Follows (data, response, error) return
<!-- language: swift -->
    let feedback = platform.getMessage("123")


The following call is used to delete a message object that was sent.
(Does not "UNSEND" the text message, simply removes from database.)
A boolean is returned to indicate success or failure.
<!-- language: swift -->
    platform.deleteMessage("123")

***

**Caution**:    The following method descriptions will be abbreviated.
                User may assume syntax will remain the same throughout.

## Account

All of the following methods return in the (data, response, error) syntax style.

**Get account ID**:
<!-- language: swift -->
    platform.getAccountId() 

**Get account and extension ID**:
<!-- language: swift -->
    platform.getAccountIdExtensionId() 

**Get extensions of current account**:
<!-- language: swift -->
    platform.getExtensions() 


## Call Log

All of the following methods return in the (data, response, error) syntax style.

**Get call log (along with applying filters)**:
<!-- language: Swift -->
    platform.getCallLog()
    
    platform.getCallLog("bunch of random filters") 
    // filters must be in the format param1=one & param2=two
    // spacing not as strict

## Presence

## Messaging

## Dictionary

## Subscription

***

# SDK Demos