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
    
    @IBOutlet var longPressLabel: UILabel!
    
    private var weatherValue: Int?
    
    var timer: NSTimer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if a user is logged in
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            print("User is logged in, send to update screen")
        } else {
            // Show the login screen
            print("User not logged in, send to login screen")
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("LoginSegueIdentifier", sender: self)
            }
        }
        
    }

    
    @IBAction func longPressed(sender: UILongPressGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            print("Long Press Ended")
            // self.timer!.invalidate()
            
            if self.longPressLabel.text == "Sunny" {
                print("Sunny")
                weatherValue = 1
                
            } else if self.longPressLabel.text == "Partly Cloudy" {
                print("Partly Cloudy")
                weatherValue = 2
                
            } else if self.longPressLabel.text == "Cloudy" {
                print("Cloudy")
                weatherValue = 3
                
            } else if self.longPressLabel.text == "Raining" {
                print("Raining")
                weatherValue = 4
                
            } else if self.longPressLabel.text == "Thunderstorm" {
                print("Thunderstorm")
                weatherValue = 5
                
            }
            
            let newWeatherUpdate = WeatherUpdate(author: PFUser.currentUser()!, weatherValue: weatherValue!)
            newWeatherUpdate.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    print("Post Update to parse successful")
                    
                    if self.weatherValue <= 2 {
                        // If user is having a great/good day ask if they want to add a drop
                        let postSuccessAlert = UIAlertController(title: "Success!", message: "Your post has been added! Would you like to send a Drop?", preferredStyle: .Alert)
                        let yesButton = UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) -> () in
                            self.performSegueWithIdentifier("MessageSegueIdentifier", sender: self)
                        })
                        let noButton = UIAlertAction(title: "No", style: .Cancel, handler: nil)
                        postSuccessAlert.addAction(yesButton)
                        postSuccessAlert.addAction(noButton)
                        self.presentViewController(postSuccessAlert, animated: true, completion: nil)
                        
                    } else {
                        // If user is having a bad day tell them drops are coming
                        let postSuccessAlert = UIAlertController(title: "Success!", message: "Your post has been added! You are amazing! Drops will be sent shortly. :)", preferredStyle: .Alert)
                        let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                        postSuccessAlert.addAction(okButton)
                        self.presentViewController(postSuccessAlert, animated: true, completion: nil)
                    }
                    
                } else {
                    print("\(error?.localizedDescription)")
                }
            }
            
            self.longPressLabel.text = "tap and hold to update"
            self.timer!.invalidate()
            
        } else if (sender.state == UIGestureRecognizerState.Began) {
            print("Long Press Began")
            
            self.startAnimatingLabel()
        }
    }
    
    // MARK: - Weather Animation
    var weatherStrings = ["Sunny", "Partly Cloudy", "Cloudy", "Raining", "Thunderstorm"]
    func animateLabel() {
        var i = 0
        for weatherString in weatherStrings {
            if self.longPressLabel.text == weatherString {
                ++i
                if i == weatherStrings.count {
                    i = 0
                }
            
            self.longPressLabel.text = weatherStrings[i]
            break
            }
        
            ++i
        }
    }
    
    func startAnimatingLabel() {
        self.longPressLabel.text = weatherStrings.first
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: ("animateLabel"), userInfo: nil, repeats: true)
    }
    
}