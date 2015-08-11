//
//  ViewController2.swift
//  demo
//
//  Created by Vincent Tseng on 6/26/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import Foundation


import UIKit

class ViewControllerPhone: UIViewController {
    
    @IBOutlet var number: UILabel!
    @IBOutlet var fromNumber: UITextField!
    @IBOutlet var message: UITextField!
    
    var platform: Platform!
    
    @IBAction func numberPressed(sender: AnyObject) {
        number.text = number.text! + sender.titleLabel!!.text!
    }
    
    @IBAction func backspace() {
        if (number.text! != "") {
            number.text = dropLast(number.text!)
        }
    }
    
    @IBAction func call() {
        // ringout
        platform.apiCall([
            "method": "POST",
            "url": "/restapi/v1.0/account/~/extension/~/ringout",
            "body": ["to": ["phoneNumber": "14088861168"],
                "from": ["phoneNumber": "14088861168"],
                "callerId": ["phoneNumber": "13464448343"],
                "playPrompt": "true"]
            ])
//        println(platform.getCallLog(true))
//        var secondTab = self.tabBarController?.viewControllers![1] as! ViewControllerLog
//        secondTab.label.text = secondTab.label.text! + "hi"
        
    }
    
    func refreshHistory() {
        
    }
    
    @IBAction func pressSMSButton(sender: AnyObject) {
        if message.text! != "" {
//            platform.postSms(message.text!, to: number.text!)
            
            var toNumber = number.text!
            
            var bodyString = "{" +
                "\"to\": [{\"phoneNumber\": " +
                "\"" + toNumber + "\"}]," +
                "\"from\": {\"phoneNumber\": \"" + fromNumber.text! +
                "\"}," + "\"text\": \"" + message.text! + "\"" + "}"
            
            platform.apiCall([
                "method": "POST",
                "url": "/restapi/v1.0/account/~/extension/~/sms",
                "body": bodyString
                ])
        }
        
    }
    
    @IBOutlet var labelPassedData: UILabel!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fromNumber.text = "14088861168"
        
        var secondTab = self.tabBarController?.viewControllers![1] as! ViewControllerLog
        secondTab.platform = self.platform
        
        platform?.testSubCall()
        
        
//        var url = NSURL(string: "https://platform.ringcentral.com/soap/" + "/ags/ws?wsdl")
//        
//        var request = NSMutableURLRequest(URL: url!)
//        request.HTTPMethod = "GET"
//        request.addValue("Bearer " + platform.auth!.getAccessToken(), forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
//            println(NSString(data: data, encoding: NSUTF8StringEncoding))
//            println(response)
//            println(error)
//            println("End")
//        }
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}