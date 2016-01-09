//
//  UpdateViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/6/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

//
// Goal for this viewcontroller is to have the user tap and hold to select how they are currently feeling.
// If the user is in a good mood we want them to add a message for others who are not in a good mood.
// If the user is having a bad day we want them to start receiving drops in their messages screen.
//

class UpdateViewController: UIViewController {
    
    @IBOutlet var longPressLabel: UILabel!
    @IBOutlet var moodImageView: UIImageView!
    
    private var weatherValue: Int?
    
    var timer: NSTimer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check to see if a user is logged in
        let currentUser = User.currentUser()
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
        
        springWithDelay(0.9, delay: 0.45, animations: {
            self.moodImageView.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            print("Long Press Ended")
            // self.timer!.invalidate()
            
            if self.longPressLabel.text == "Sunny" {
                print("Sunny")
                weatherValue = 1
                startAnimatingFaces()
                
            } else if self.longPressLabel.text == "Partly Cloudy" {
                print("Partly Cloudy")
                weatherValue = 2
                startAnimatingFaces()
                
            } else if self.longPressLabel.text == "Cloudy" {
                print("Cloudy")
                weatherValue = 3
                startAnimatingFaces()
                
            } else if self.longPressLabel.text == "Raining" {
                print("Raining")
                weatherValue = 4
                startAnimatingFaces()
                
            } else if self.longPressLabel.text == "Thunderstorm" {
                print("Thunderstorm")
                weatherValue = 5
                startAnimatingFaces()
                
            }
            
            createNewWeatherUpdate()
            
            self.longPressLabel.text = "tap and hold to update"
            self.moodImageView.image = nil
            self.timer!.invalidate()
            
        } else if (sender.state == UIGestureRecognizerState.Began) {
            print("Long Press Began")
            
            self.startAnimatingLabel()
        }
    }
    
    func createNewWeatherUpdate() {
        
        let newWeatherUpdate = WeatherUpdate(author: User.currentUser()!, weatherValue: weatherValue!)
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
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: ("animateLabel"), userInfo: nil, repeats: true)
    }
    
    // need to figure out how to get these to run through while the label is changing.
    func startAnimatingFaces() {
        if self.longPressLabel.text == "Sunny" {
            moodImageView.image = UIImage(named:"Big Smile Face")!
            
        } else if self.longPressLabel.text == "Partly Cloudy" {
            moodImageView.image = UIImage(named:"Happy Face")!
            print("test")
            
        } else if self.longPressLabel.text == "Cloudy" {
            moodImageView.image = UIImage(named:"Sad Face")!
            
        } else if self.longPressLabel.text == "Raining" {
            moodImageView.image = UIImage(named:"Crying Face")!
            
        } else if self.longPressLabel.text == "Thunderstorm" {
            moodImageView.image = UIImage(named:"Angry Face")!
        }
    }
    
}