RingCentral Swift SDK
=====================

***

1. [Overview](#overview)
2. [Setting Up](#setting-up)
3. [Initialization](#initialization)
4. [Authorization](#authorization)
5. [Performing RingOut](#ring-out)
6. [Sending SMS](#sending-sms)
7. [Generic Requests](#generic-requests)
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
var sdk = init(appKey, appSecret, Sdk.RC_SERVER_SANDBOX)
```

or 

Production:

```swift
var sdk = init(appKey, appSecret, Sdk.RC_SERVER_PRODUCTION)
```

Production:

# Authorization

***

# Performing RingOut

# Sending SMS

***

# Generic Requests

## Account

## Call Log

## Presence

## Messaging

## Dictionary

## Subscription

***

# SDK Demos