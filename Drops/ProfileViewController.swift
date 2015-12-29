//
//  ProfileViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/22/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    @IBOutlet var totalUpdatesLabel: UILabel!
    @IBOutlet var totalDropsLabel: UILabel!
    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var currentMoodLabel: UILabel!
    @IBOutlet var userProfileTextLabel: UILabel!
    @IBOutlet var formView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = PFUser.currentUser()
        
        self.formView.alpha = 0
        
        self.totalUpdatesLabel.text = ""
        self.totalDropsLabel.text = ""
        self.usernameLabel.text = ""
        self.currentMoodLabel.text = ""
        self.userProfileTextLabel.text = ""
        
        // Round the corners of the transparent formview
        self.formView.layer.cornerRadius = 10
        self.formView.clipsToBounds = true;
        
        self.formView.fadeIn()
        
        // Get the latest weather update
        let currentMood = PFQuery(className: "WeatherUpdate")
        currentMood.whereKey("author", equalTo: currentUser!)
        currentMood.orderByDescending("createdAt")
        currentMood.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The currentMood request failed.")
            } else {
                // The find succeeded.
                print("Successfully retrieved the current mood object.")
                let moodNumber = object!["weatherValue"]
                self.currentMoodLabel.text = "\(moodNumber) current mood"
            }
        }
        
        // Get the number of messages/drops for the current user
        let messageCount = PFQuery(className:"Message")
        messageCount.whereKey("author", equalTo: currentUser!)
        messageCount.countObjectsInBackgroundWithBlock {
            (count: Int32, error: NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved messages count")
                self.totalDropsLabel.text = "\(count) Drops"
            }
        }
        
        // Get the number of updates for current user
        let updateCount = PFQuery(className:"WeatherUpdate")
        updateCount.whereKey("author", equalTo: currentUser!)
        updateCount.countObjectsInBackgroundWithBlock {
            (count: Int32, error: NSError?) -> Void in
            if error == nil {
                print("Successfully retrieved updates count")
                self.totalUpdatesLabel.text = "\(count) Updates"
            }
        }
        
        // get current user info
        let query = PFUser.query()
        query!.whereKey("username", equalTo: currentUser!.username!)
        query!.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The user info query request failed.")
            } else {
                // The find succeeded.
                
                let userProfileImageFile = object!["profileImageFile"] as? PFFile
                userProfileImageFile!.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.userProfileImage.image = UIImage(data:imageData)
                        }
                    }
                }
                
                self.usernameLabel.text = object!["username"] as? String
                
                self.userProfileTextLabel.text = object!["profileText"] as? String
                
                print("Successfully retrieved the user info.")
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
