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
    
    
    @IBAction func numberPressed(sender: AnyObject) {
        println(sender.titleLabel!!.text!)
    }
    
    @IBAction func backspace() {
        
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