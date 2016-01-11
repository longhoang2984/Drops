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
    @IBOutlet var longPressSpringLabel: SpringLabel!
    @IBOutlet var moodImageView: UIImageView!
    @IBOutlet var moodSpringImageView: SpringImageView!
    @IBOutlet var sunSpringImageView: SpringImageView!
    
    private var weatherValue: Int?
    
    var timer: NSTimer?
    var count = 0
    
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
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            print("Long Press Ended")
            self.timer!.invalidate()
            
            if count > 0 {
                weatherValue = count
                createNewWeatherUpdate()
            }

            self.longPressLabel.text = "press and hold to add update"
            longPressSpringLabel.animation = "fadeIn"
            longPressSpringLabel.curve = "spring"
            longPressSpringLabel.duration = 1
            longPressSpringLabel.animate()
            
            sunSpringImageView.animation = "fall"
            sunSpringImageView.curve = "spring"
            sunSpringImageView.duration = 1
            sunSpringImageView.animate()
            
            moodSpringImageView.alpha = 0
            
        } else if (sender.state == UIGestureRecognizerState.Began) {
            print("Long Press Began")
            count = 0
            
            sunSpringImageView.hidden = false
            sunSpringImageView.animation = "squeezeDown"
            sunSpringImageView.curve = "spring"
            sunSpringImageView.duration = 2
            sunSpringImageView.animate()
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: ("startCounter"), userInfo: nil, repeats: true)
            
            longPressSpringLabel.animation = "fadeOut"
            longPressSpringLabel.curve = "spring"
            longPressSpringLabel.duration = 1
            longPressSpringLabel.animate()
            
            
        }
    }
    
    
    func createNewWeatherUpdate() {
        
        let newWeatherUpdate = WeatherUpdate(author: User.currentUser()!, weatherValue: weatherValue!)
        newWeatherUpdate.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                print("Post Update to parse successful")
                print(self.weatherValue)
                
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
                    self.count = 0
                    
                } else {
                    // If user is having a bad day tell them drops are coming
                    let postSuccessAlert = UIAlertController(title: "Success!", message: "Your post has been added! You are amazing! Drops will be sent shortly. :)", preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    postSuccessAlert.addAction(okButton)
                    self.presentViewController(postSuccessAlert, animated: true, completion: nil)
                    self.count = 0
                }
                
            } else {
                print("\(error?.localizedDescription)")
                self.count = 0
            }
        }
    }
    
    // MARK: - Animations and counter
    func startCounter() {
        count++
        print(count)
        if count == 5 {
            
            self.longPressLabel.text = "Thunderstorm"
            self.moodImageView.image = UIImage(named: "angry-face")
            longPressSpringLabel.animation = "fadeInUp"
            longPressSpringLabel.duration = 0.5
            longPressSpringLabel.animate()
            
        } else if count == 4 {
            self.longPressLabel.text = "Raining"
            self.moodImageView.image = UIImage(named: "crying-face")
            longPressSpringLabel.animation = "fadeInUp"
            longPressSpringLabel.duration = 0.5
            longPressSpringLabel.animate()
            
        } else if count == 3 {
            self.longPressLabel.text = "Cloudy"
            self.moodImageView.image = UIImage(named: "sad-face")
            longPressSpringLabel.animation = "fadeInUp"
            longPressSpringLabel.duration = 0.5
            longPressSpringLabel.animate()
            
        } else if count == 2 {
            self.longPressLabel.text = "Partly Cloudy"
            self.moodImageView.image = UIImage(named: "smiley-face")
            longPressSpringLabel.animation = "fadeInUp"
            longPressSpringLabel.duration = 0.5
            longPressSpringLabel.animate()
            
        } else if count == 1 {
            self.longPressLabel.text = "Sunny"
            self.moodImageView.image = UIImage(named: "happy-face")
            longPressSpringLabel.animation = "fadeInUp"
            longPressSpringLabel.duration = 0.5
            longPressSpringLabel.animate()
            
        } else if count == 0 {
            self.moodImageView.image = nil
            
        }
        
        moodSpringImageView.animation = "morph"
        moodSpringImageView.animate()
    }
    
}