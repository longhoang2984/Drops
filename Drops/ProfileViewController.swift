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
    
    var backgroundImage:UIImage!
    
    var backgroundImageView1:UIImageView!
    var backgroundImageView2:UIImageView!

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
                            self.userProfileImage.contentMode = .ScaleAspectFill
                            self.userProfileImage.layer.cornerRadius = 25.0
                            self.userProfileImage.layer.borderWidth = 0.0
                            self.userProfileImage.clipsToBounds = true
                        }
                    }
                }
                
                self.usernameLabel.text = object!["username"] as? String
                
                self.userProfileTextLabel.text = object!["profileText"] as? String
                
                print("Successfully retrieved the user info.")
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateBackground()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // UIImageView 1
        if(backgroundImageView1 != nil){
            backgroundImageView1.removeFromSuperview()
            backgroundImageView1 = nil
        }
        if(backgroundImageView2 != nil){
            backgroundImageView2.removeFromSuperview()
            backgroundImageView2 = nil
        }
        
    }
    
    func animateBackground() {
        backgroundImage = UIImage(named:"backgroundPattern.png")!
        let amountToKeepImageSquare = (backgroundImage.size.height - self.view.frame.size.height)
        
        // UIImageView 1
        if(backgroundImageView1 != nil){
            backgroundImageView1.removeFromSuperview()
            backgroundImageView1 = nil
        }
        if(backgroundImageView2 != nil){
            backgroundImageView2.removeFromSuperview()
            backgroundImageView2 = nil
        }
        
        backgroundImageView1 = UIImageView(image: backgroundImage)
        backgroundImageView1.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: backgroundImage.size.width - amountToKeepImageSquare, height: self.view.frame.size.height)
        self.view.addSubview(backgroundImageView1)
        
        // UIImageView 2
        backgroundImageView2 = UIImageView(image: backgroundImage)
        backgroundImageView2.frame = CGRect(x: backgroundImageView1.frame.size.width, y: self.view.frame.origin.y, width: backgroundImage.size.width - amountToKeepImageSquare, height: self.view.frame.height)
        self.view.addSubview(backgroundImageView2)
        
        self.view.sendSubviewToBack(backgroundImageView1)
        self.view.sendSubviewToBack(backgroundImageView2)
        
        // Animate background
        UIView.animateWithDuration(15, delay: 0.0, options: [.Repeat, .CurveLinear], animations: {
            self.backgroundImageView1.frame = CGRectOffset(self.backgroundImageView1.frame, -1 * self.backgroundImageView1.frame.size.width, 0.0)
            self.backgroundImageView2.frame = CGRectOffset(self.backgroundImageView2.frame, -1 * self.backgroundImageView2.frame.size.width, 0.0)
            }, completion: nil)
    }

}
