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
    @IBOutlet var leftCloudSpringImageView: SpringImageView!
    @IBOutlet var centerCloudSpringImage: SpringImageView!
    @IBOutlet var rightCloudSpringImageView: SpringImageView!
    @IBOutlet var greySpringView: SpringView!
    @IBOutlet var leftRainSpringImagView: SpringImageView!
    @IBOutlet var centerRainSpringImageView: SpringImageView!
    @IBOutlet var rightRainSpringImageView: SpringImageView!
    @IBOutlet var lightningBoltSpringImageView: SpringImageView!
    
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
            
            self.longPressLabel.text = "press and hold to add update"
            longPressSpringLabel.animation = "fadeIn"
            longPressSpringLabel.curve = "spring"
            longPressSpringLabel.duration = 1
            longPressSpringLabel.animate()
            
            leftRainSpringImagView.alpha = 0
            centerRainSpringImageView.alpha = 0
            rightRainSpringImageView.alpha = 0
            lightningBoltSpringImageView.alpha = 0
            
            if count > 0 {
                weatherValue = count
                createNewWeatherUpdate()
                
                moodSpringImageView.animation = "fadeOut"
                moodSpringImageView.animate()
            }
            
            if count > 1 {
                leftCloudSpringImageView.animation = "fadeOut"
                leftCloudSpringImageView.duration = 0.5
                leftCloudSpringImageView.animate()
                
                rightCloudSpringImageView.animation = "fadeOut"
                rightCloudSpringImageView.duration = 0.5
                rightCloudSpringImageView.animate()
            }
            
            if count > 2 {
                centerCloudSpringImage.animation = "fadeOut"
                centerCloudSpringImage.duration = 0.5
                centerCloudSpringImage.animate()
                
                greySpringView.animation = "fadeOut"
                greySpringView.duration = 0.5
                greySpringView.animate()
            }
            
            if count == 5 {
                lightningBoltSpringImageView.animation = "fadeOut"
                lightningBoltSpringImageView.duration = 0.5
                lightningBoltSpringImageView.animate()
            }
            
            sunSpringImageView.animation = "fall"
            sunSpringImageView.curve = "spring"
            sunSpringImageView.duration = 1
            sunSpringImageView.animate()

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
        count = (count + 1)%6
        print(count)
        if count == 5 {
            thunderstorm()
            
        } else if count == 4 {
            raining()
            
        } else if count == 3 {
            cloudy()
            
        } else if count == 2 {
            partlyCloudy()
            
        } else if count == 1 {
            sunny()
            
        } else if count == 0 {
            self.moodImageView.image = nil
            
            leftRainSpringImagView.alpha = 0
            centerRainSpringImageView.alpha = 0
            rightRainSpringImageView.alpha = 0
            
            sunSpringImageView.hidden = false
            sunSpringImageView.animation = "squeezeDown"
            sunSpringImageView.curve = "spring"
            sunSpringImageView.duration = 2
            sunSpringImageView.animate()
            
            if greySpringView.hidden == false {
                greySpringView.animation = "fadeOut"
                greySpringView.curve = "easeIn"
                greySpringView.duration = 0.5
                greySpringView.delay = 0
                greySpringView.animate()
            }
            
            longPressSpringLabel.animation = "fadeOut"
            longPressSpringLabel.duration = 0.5
            longPressSpringLabel.animate()
            
            leftCloudSpringImageView.animation = "fadeOut"
            leftCloudSpringImageView.duration = 0.5
            leftCloudSpringImageView.animate()
            
            centerCloudSpringImage.animation = "fadeOut"
            centerCloudSpringImage.duration = 0.5
            centerCloudSpringImage.animate()
            
            rightCloudSpringImageView.animation = "fadeOut"
            rightCloudSpringImageView.duration = 0.5
            rightCloudSpringImageView.animate()
            
            lightningBoltSpringImageView.animation = "fadeOut"
            lightningBoltSpringImageView.duration = 0.5
            lightningBoltSpringImageView.animate()
            
        }
        
        moodSpringImageView.animation = "morph"
        moodSpringImageView.duration = 1
        moodSpringImageView.animate()
    }
    
    func sunny() {
        greySpringView.hidden = true
        
        moodImageView.image = UIImage(named: "happy-face")
        
        longPressLabel.text = "Sunny"
        longPressSpringLabel.animation = "fadeInUp"
        longPressSpringLabel.duration = 0.4
        longPressSpringLabel.animate()
    }
    
    func partlyCloudy() {
        leftCloudSpringImageView.animation = "squeezeRight"
        leftCloudSpringImageView.curve = "easeInOutBack"
        leftCloudSpringImageView.duration = 1.2
        leftCloudSpringImageView.velocity = 0.5
        leftCloudSpringImageView.animate()
        
        rightCloudSpringImageView.animation = "squeezeLeft"
        rightCloudSpringImageView.curve = "easeInOutBack"
        rightCloudSpringImageView.duration = 1.2
        rightCloudSpringImageView.velocity = 0.5
        rightCloudSpringImageView.animate()
        
        moodImageView.image = UIImage(named: "smiley-face")
        
        longPressLabel.text = "Partly Cloudy"
        longPressSpringLabel.animation = "fadeInUp"
        longPressSpringLabel.duration = 0.4
        longPressSpringLabel.animate()
    }
    
    func cloudy() {
        greySpringView.hidden = false
        greySpringView.animation = "fadeIn"
        greySpringView.curve = "linear"
        greySpringView.duration = 4
        greySpringView.delay = 1
        greySpringView.animate()
        
        centerCloudSpringImage.alpha = 1
        centerCloudSpringImage.animation = "squeezeDown"
        centerCloudSpringImage.curve = "easeInOutBack"
        centerCloudSpringImage.duration = 1.2
        centerCloudSpringImage.velocity = 0.5
        centerCloudSpringImage.animate()
        
        moodImageView.image = UIImage(named: "sad-face")
        
        longPressLabel.text = "Cloudy"
        longPressSpringLabel.animation = "fadeInUp"
        longPressSpringLabel.duration = 0.4
        longPressSpringLabel.animate()
        
        sunSpringImageView.animation = "fadeOut"
        sunSpringImageView.curve = "linear"
        sunSpringImageView.duration = 1
        sunSpringImageView.animate()
    }
    
    func raining() {
        leftRainSpringImagView.alpha = 1
        leftRainSpringImagView.animation = "fadeIn"
        leftRainSpringImagView.curve = "easeIn"
        leftRainSpringImagView.duration = 0.7
        leftRainSpringImagView.animateNext { () -> () in
            self.leftRainSpringImagView.animation = "fall"
            self.leftRainSpringImagView.duration = 5
            self.leftRainSpringImagView.animate()
        }
        
        centerRainSpringImageView.alpha = 1
        centerRainSpringImageView.animation = "fadeIn"
        centerRainSpringImageView.curve = "easeIn"
        centerRainSpringImageView.duration = 0.9
        centerRainSpringImageView.animateNext { () -> () in
            self.centerRainSpringImageView.animation = "fall"
            self.centerRainSpringImageView.duration = 5
            self.centerRainSpringImageView.animate()
        }
        
        rightRainSpringImageView.alpha = 1
        rightRainSpringImageView.animation = "fadeIn"
        rightRainSpringImageView.curve = "easeIn"
        rightRainSpringImageView.duration = 0.5
        rightRainSpringImageView.animateNext { () -> () in
            self.rightRainSpringImageView.animation = "fall"
            self.rightRainSpringImageView.duration = 3
            self.rightRainSpringImageView.animate()
        }
        
        moodImageView.image = UIImage(named: "crying-face")
        
        longPressLabel.text = "Raining"
        longPressSpringLabel.animation = "fadeInUp"
        longPressSpringLabel.duration = 0.4
        longPressSpringLabel.animate()
    }
    
    func thunderstorm() {
        lightningBoltSpringImageView.alpha = 1
        lightningBoltSpringImageView.animation = "fadeIn"
        lightningBoltSpringImageView.curve = "spring"
        lightningBoltSpringImageView.duration = 0.5
        // lightningBoltSpringImageView.repeatCount = 2
        lightningBoltSpringImageView.animateToNext({ () -> () in
            self.lightningBoltSpringImageView.animation = "wobble"
            self.lightningBoltSpringImageView.curve = "spring"
            self.lightningBoltSpringImageView.duration = 0.5
            self.lightningBoltSpringImageView.animate()
        })
        
        moodImageView.image = UIImage(named: "angry-face")
        
        longPressLabel.text = "Thunderstorm"
        longPressSpringLabel.animation = "fadeInUp"
        longPressSpringLabel.duration = 0.4
        longPressSpringLabel.animate()
    }
    
}