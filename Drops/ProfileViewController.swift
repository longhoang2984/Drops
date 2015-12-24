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
        
        // get current user
        let query = PFUser.query()
        let currentUser = PFUser.currentUser()
        query!.whereKey("username", equalTo: currentUser!.username!)
        query!.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                print("The getFirstObject request failed.")
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
                
                // need to count user created updates. I think will have to do with cloud code and update a seperate column in the user class.
                self.totalUpdatesLabel.text = "0 Updates"
                
                // need to count user created messages. I think will have to do with cloud code and update a seperate column in the user class.
                self.totalDropsLabel.text = "0 Drops"
                
                self.usernameLabel.text = object!["username"] as? String
                
                // need to get the latest weather update
                self.currentMoodLabel.text = "Latest Weather Update"
                
                self.userProfileTextLabel.text = object!["profileText"] as? String
                
                print("Successfully retrieved the object.")
            }
        }
        
        print(User.currentUser())

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
