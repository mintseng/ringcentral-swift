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

For now, drag the "swift-sdk" folder into your directory.
A better implementation with Pods will be used in future.

To set up CocoaPods:
<!-- language: cmd -->
    $ sudo gem install cocoapods

The same line is used to update cocoapods accordingly.
Set up a new Xcode project, and navigate to it within Terminal.

Within Terminal, type:
<!-- language: cmd -->
    $ pod init
    $ open -a Xcode Podfile

That will set up a Podfile and open it.
Add the following code into the newly created Podfile
<!-- language: cmd -->
    platform :ios, '8.0'
    target 'YourProject' do
    source 'https://github.com/CocoaPods/Specs.git'
    pod 'PubNub', '~>4.0'
    end
    target 'YourProjectTests' do
    end

Go back into terminal and type the following:
<!-- language: cmd -->
    $ pod update
    $ pod install

Next you will need to add an Objective-C bridging header.
Create a new File (File -> New -> File) of type Objective-C.
You will be promped "Would you like to configure an Objective-C bridging header?".
Select Yes, and insert the following into the Bridging Header file (.h).
<!-- language: swift -->
    #import <PubNub/PubNub.h>
You will now be able to use the PubNub SDK written in Objective-C.

# Initialization

The RingCentral SDK is initiated in the following ways.

**Sandbox:**
<!-- language: swift -->
    var rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_SANDBOX)

**Production:**
<!-- language: swift -->
    var rcsdk = SDK(appKey: app_key, appSecret: app_secret, server: SDK.RC_SERVER_PRODUCTION)


Depending on the stage of production, either                                        
**SDK.RC_SERVER_SANDBOX** or **SDK.RC_SERVER_PRODUCTION**                                   
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

Currently, all method calls support a standard (DATA, RESPONSE, ERROR) return protocal
or returns a Response object containing the same things.
A parsing class will be provided to use at your disposal, however the functionality of
what it returns is limited (based on what developers will likely need most).

**Most method calls will follow this behavior:**
<!-- language: swift -->
    platform.apiCall([
        "method": "POST",
        "url": "/v1.0/account/~/extension/~/ringout",
        "body": platform.ringOutSyntax("4088861168", from: "4088861168")
        ]) { (data, response, error) in
            // insert code within this callback section
        }

Rule of thumb: Always check if 'error' is nil
<!-- language: swift -->
    { (data, response, error) in
        if (error) {
            // do something for error
        } else {
            // continue with code
        }
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
<!-- language: lang-swift -->
    platform.getCallLog()
    
    platform.getCallLog("bunch of random filters") 
    // filters must be in the format param1=one & param2=two
    // spacing not as strict

## Presence

**Gets the presence of any calls on the current account**:
<!-- language: swift -->
    platform.getPresence()

## Messaging

The following call is used to obtain a message that was sent.
Follows (data, response, error) return
<!-- language: swift -->
    let feedback = platform.getMessage("123") // message ID
    // or
    let feedback = platform.getMessages("123") //conversation ID

**Changes the message (currently only supports "READ" <--> "UNREAD" switching)**
<!-- language: swift -->
    platform.postMessage("123", text:"hi i'm min") // message ID

**Gets the attachment of a message**:
<!-- language: swift -->
    platform.getAttachment("123", attachId: "1234") // message ID and attachment ID

## Dictionary

**Gets the country**:
<!-- language: swift -->
    platform.getCountry("1") // country ID

**Gets the list of all the countries**:
<!-- language: swift -->
    platform.getCountries()

**Gets the state**:
<!-- language: swift -->
    platform.getState("123") // state ID

**Gets all of the states within a specified country**:
<!-- language: swift -->
    platform.getStates()

**Gets all locations within a state**:
<!-- language: swift -->
    platform.getLocations("123") // state ID

**Gets a timezone**:
<!-- language: swift -->
    platform.getTimezone("123") // zone ID

**Gets a language**:
<!-- language: swift -->
    platform.getLanguage("123") // language ID

**Gets all of the languages**:
<!-- language: swift -->
    platform.getLanguages()


## Subscription

Currently in progress.
As of now, responses to console can be obtained, however not as actaul objects.
Can visibly see real time responses for subscription.

***

# SDK Demos

1. Single page graphics UI showcasing the usability of all API function calls.

2. Features Login page transitioning into a pseudo-phone graphics UI, which transitions into a call log.





