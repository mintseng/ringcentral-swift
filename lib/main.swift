//
//  main.swift
//  lib
//
//  Created by Vincent Tseng on 7/20/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import Foundation

println("Hello, World!")

var context = Swift.Dictionary<String, Any>()
context["method"] = "POST"
context["url"] = "/v1.0/account/~/extension/~/ringout"
context["body"] = ["to": ["phoneNumber": "14088861168"],
    "from": ["phoneNumber": "14088861168"],
    "callerId": ["phoneNumber": "13464448343"],
    "playPrompt": "true"]
