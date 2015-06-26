//
//  ViewController.swift
//  demo
//
//  Created by Vincent Tseng on 6/25/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var app_key: String = "eI3RKs1oSBSY2kReFnviIw"
        var app_secret = "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ"
        var username = "13464448343"
        //var ext = "102"
        var password = "P@ssw0rd"
        
        var rcsdk = Sdk(appKey: app_key, appSecret: app_secret, server: Sdk.RC_SERVER_SANDBOX)
        
        var platform = rcsdk.getPlatform()
        
        platform.authorize(username, password: password)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

