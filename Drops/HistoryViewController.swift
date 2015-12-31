//
//  HistoryViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/28/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var historyTableView: UITableView!
    
    var updateHistoryData:NSMutableArray! = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        
        // Get the weather updates
        let fetchUpdates = PFQuery(className: "WeatherUpdate")
        fetchUpdates.whereKey("author", equalTo: currentUser!)
        fetchUpdates.orderByDescending("createdAt")
        fetchUpdates.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) weather updates.")
                // Do something with the found objects
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        let update:PFObject = object
                        self.updateHistoryData.addObject(update)
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        //reload UIViewController && Tableview
        sleep(3)
        
        do_table_refresh()
        
    }
    
    //reload tableview
    func do_table_refresh() {
        dispatch_async(dispatch_get_main_queue(), {
            self.historyTableView.reloadData()
            return
        })
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return updateHistoryData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        let update:PFObject = self.updateHistoryData.objectAtIndex(indexPath.row) as! PFObject
        
        cell.timeAgoLabel.text = "\(update.createdAt!)"
        cell.updateLabel.text = "\(update.objectForKey("weatherValue")!)"

        return cell
    }

}