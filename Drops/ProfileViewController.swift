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
        
        // Round the corners of the transparent formview
        self.formView.layer.cornerRadius = 10
        self.formView.clipsToBounds = true;
        
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
                
                let totalUpdates = object!["weatherUpdates"] as? [String]
                self.totalUpdatesLabel.text = "\(totalUpdates?.count) Updates"
                
                let userProfileImageFile = object!["profileImageFile"] as? PFFile
                userProfileImageFile!.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.userProfileImage.image = UIImage(data:imageData)
                        }
                    }
                }
                
                let totalDrops = object!["createdMessages"] as? [String]
                self.totalDropsLabel.text = "\(totalDrops?.count) Drops"
                
                self.usernameLabel.text = object!["username"] as? String
                
                let currentMood = totalUpdates?.first
                self.currentMoodLabel.text = currentMood
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
