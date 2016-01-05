//
//  ForgotPasswordViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/7/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var formView: UIView!
    @IBOutlet var newPasswordButton: UIButton!
    
    private var email: String!
    
    var backgroundImage:UIImage!
    
    var backgroundImageView1:UIImageView!
    var backgroundImageView2:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round the corners of the transparent formview
        self.formView.layer.cornerRadius = 10
        self.formView.clipsToBounds = true;
        
        // Round the corners of the registerButton
        self.newPasswordButton.layer.cornerRadius = 5
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
    
    @IBAction func passwordResetButtonClicked()
    {
        if emailTextField.text == nil {
            print("no email")
        } else {
            let email = emailTextField.text!
            PFUser.requestPasswordResetForEmailInBackground(email)
            print("Password Reset Email Sent")
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func backButtonClicked()
    {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    // Go to next textfield or submit when return key is touched
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.emailTextField {
            self.view.endEditing(true)
            passwordResetButtonClicked()
        }
        return true
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
