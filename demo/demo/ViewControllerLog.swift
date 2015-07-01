//
//  ViewController3.swift
//  demo
//
//  Created by Vincent Tseng on 6/26/15.
//  Copyright (c) 2015 Vincent Tseng. All rights reserved.
//

import Foundation


import UIKit

class ViewControllerLog: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var filter: UITextField!
    @IBOutlet var callHistory: UITableView!
    var platform: Platform!
    
//    @IBOutlet var label: UILabel!
    
    var textArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for call in platform.getCallLog(true)["records"] as! NSArray {
            var part0: String = (call["startTime"] as! String) + "\n"
            var part1: String = (call["direction"] as! String) + " (Id: " + (call["id"] as! String) + ")\n"
            var part2: String = ((call["from"] as! NSDictionary)["phoneNumber"] as! String) + " --> " + ((call["to"] as! NSDictionary)["phoneNumber"] as! String)
            self.textArray.addObject(part0 + part1 + part2)

        }
        
        self.callHistory.rowHeight = UITableViewAutomaticDimension
        self.callHistory.estimatedRowHeight = 44.0
        
    }
    
    @IBAction func press(sender: AnyObject) {
        self.textArray.addObject("Hi")
        filter(filter.text)
        self.callHistory.reloadData()
    }
    
    func filter(filter: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.textArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell: UITableViewCell = self.callHistory.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
//        cell.textLabel!.text = "hi"
        cell!.textLabel?.text = self.textArray.objectAtIndex(indexPath.row) as? String
        cell!.textLabel?.adjustsFontSizeToFitWidth = true
        
        // Setting number of lines to 0 allows for self adaptive lines
        cell!.textLabel?.numberOfLines = 3
        return cell!
    }
    
    
    
    
}