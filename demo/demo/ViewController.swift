//
//  ViewController.swift
//  demo
//
//  Created by Vincent Tseng on 6/25/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet weak var userBox: UITextField!
    @IBOutlet weak var passBox: UITextField!
    @IBOutlet weak var keyBox: UITextField!
    @IBOutlet weak var secretBox: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        
        
        var rcsdk = Sdk(appKey: keyBox.text, appSecret: secretBox.text, server: Sdk.RC_SERVER_SANDBOX)
        var platform = rcsdk.getPlatform()
        
        var feedback = platform.authorize(userBox.text, password: passBox.text)
        
        
        if (false) {
            performSegueWithIdentifier("loginToMain", sender: nil)
        } else {
            shakeButton(sender)
        }
        
    }
    
    func shakeButton(sender: AnyObject) {
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        sender.layer.addAnimation( anim, forKey:nil )
    }
    
    @IBAction func setValues() {
        userBox.text = "13464448343"
        passBox.text = "P@ssw0rd"
        keyBox.text = "eI3RKs1oSBSY2kReFnviIw"
        secretBox.text = "Gv9DgBZVTkaQNbbyEx-SQQBsnUKECmT5GrmGXbHTmpUQ"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

