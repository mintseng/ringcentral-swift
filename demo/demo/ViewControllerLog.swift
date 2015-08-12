import Foundation

import UIKit

class ViewControllerLog: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var filter: UITextField!
    @IBOutlet var callHistory: UITableView!
    var platform: Platform!
    
    @IBOutlet var messageHistory: UITableView!
//    @IBOutlet var label: UILabel!
    
    var textArray: NSMutableArray = NSMutableArray()
    var messageArray: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        platform.apiCall([
                "method": "GET",
                "url": "/restapi/v1.0/account/~/call-log"
            ]) {
                (data, response, error) in
                for call in (NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary)["records"] as! NSArray {
                    var part0: String = (call["startTime"] as! String) + "\n"
                    var part1: String = (call["direction"] as! String) + " (Id: " + (call["id"] as! String) + ")\n"
                    var part2: String = ((call["from"] as! NSDictionary)["phoneNumber"] as! String) + " --> " + ((call["to"] as! NSDictionary)["phoneNumber"] as! String)
                    self.textArray.addObject(part0 + part1 + part2)
                }
        }
        
//        for call in platform.getCallLog(true)["records"] as! NSArray {
//            var part0: String = (call["startTime"] as! String) + "\n"
//            var part1: String = (call["direction"] as! String) + " (Id: " + (call["id"] as! String) + ")\n"
//            var part2: String = ((call["from"] as! NSDictionary)["phoneNumber"] as! String) + " --> " + ((call["to"] as! NSDictionary)["phoneNumber"] as! String)
//            self.textArray.addObject(part0 + part1 + part2)
//
//        }
        
//        var feedback = platform.getMessages()
        
        platform.apiCall([
            "method": "GET",
            "url": "/restapi/v1.0/account/~/extension/~/message-store",
            "headers": ["Accept": "application/json"],
            ]) {
                (data, response, error) in
//                println((NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary) ["records"]! as! NSArray)
                
                for message in (NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary) ["records"]! as! NSArray {
                    let direction = message["direction"] as! String
                    var part0: String = direction
                    let number: String
                    if direction == "Outbound" {
                        number = (message["to"] as! NSArray)[0]["phoneNumber"] as! String
                    } else {
                        number = (message["from"] as! NSDictionary) ["phoneNumber"] as! String
                    }
//                    var part1: String = (message["subject"] as! String)
                    var part1: String
                    
                    if let person = message["subject"] as? String {
                        part1 = person
                    } else {
                        part1 = "UNKNOWN"
                    }
                    
                    self.messageArray.addObject(part0 + ": " + number + "\n" + part1)
                }
                
        }
        
//        for message in (NSJSONSerialization.JSONObjectWithData(feedback.0!, options: nil, error: nil) as! NSDictionary) ["records"]! as! NSArray{
//            let direction = message["direction"] as! String
//            var part0: String = direction
//            let number: String
//            if direction == "Outbound" {
//                number = (message["to"] as! NSArray)[0]["phoneNumber"] as! String
//            } else {
//                number = (message["from"] as! NSDictionary) ["phoneNumber"] as! String
//            }
//            var part1: String = (message["subject"] as! String)
//            self.messageArray.addObject(part0 + ": " + number + "\n" + part1)
//        }
//        
        self.callHistory.rowHeight = UITableViewAutomaticDimension
        self.callHistory.estimatedRowHeight = 44.0
        
        self.messageHistory.reloadData()
        self.callHistory.reloadData()
        
    }
    
    @IBAction func press(sender: AnyObject) {
        self.textArray.addObject("Hi")
        filter(filter.text)
        self.callHistory.reloadData()
        
        self.messageHistory.reloadData()
        self.callHistory.reloadData()
    }
    
    func filter(filter: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == callHistory {
            return self.textArray.count
        }
        return self.messageArray.count
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell: UITableViewCell = self.callHistory.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        if tableView == self.callHistory {
            let cellIdentifier = "Cell"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            }
            //        cell.textLabel!.text = "hi"
            cell!.textLabel?.text = self.textArray.objectAtIndex(indexPath.row) as? String
            cell!.textLabel?.adjustsFontSizeToFitWidth = true
            
            // Setting number of lines to 0 allows for self adaptive lines
            cell!.textLabel?.numberOfLines = 0
            return cell!
        } else {
            let cellIdentifier = "Message"
            
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
            }
            //        cell.textLabel!.text = "hi"
            cell!.textLabel?.text = self.messageArray.objectAtIndex(indexPath.row) as? String
            cell!.textLabel?.adjustsFontSizeToFitWidth = true
            
            // Setting number of lines to 0 allows for self adaptive lines
            cell!.textLabel?.numberOfLines = 0
            
            return cell!
            
        }
        
        

        
    }
    
    
    
    
}