//
//  UpdateViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/6/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class UpdateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Check to see if a user is logged in
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
        } else {
            // Show the login screen
            print("User not logged in, send to login screen")
//            dispatch_async(dispatch_get_main_queue()){
//                self.performSegueWithIdentifier("LoginSegueIdentifier", sender: self)
//            }
        }
        
        }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}