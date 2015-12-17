//
//  SettingsViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/16/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonClicked() {
        PFUser.logOut()
        let currentUser = PFUser.currentUser()
        if currentUser == nil {
            print("User logged out")
            dispatch_async(dispatch_get_main_queue()){
                self.tabBarController?.selectedIndex = 0
            }
        }
    }

}
