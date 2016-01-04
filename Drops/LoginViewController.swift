//
//  LoginViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/7/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var formView: UIView!
    @IBOutlet var loginButton: UIButton!
    
    private var username: String!
    private var password: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // Round the corners of the transparent formview
        self.formView.layer.cornerRadius = 10
        self.formView.clipsToBounds = true;
        
        // Round the corners of the registerButton
        self.loginButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        animateBackground()
    }
    
    @IBAction func loginButtonClicked() {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            print("error!")

            if usernameTextField.text == "" {
                
                print("No username")
                let usernameErrorAlert = UIAlertController(title: "Oops!", message: "We have no username to log you in with. Please input your username and try again.", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                usernameErrorAlert.addAction(okButton)
                self.presentViewController(usernameErrorAlert, animated: true, completion: nil)
                
            } else if passwordTextField.text == "" {
                
                print("No Password")
                let passwordErrorAlert = UIAlertController(title: "Oops!", message: "We have no password to log you in with. Please input your password and try again.", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                passwordErrorAlert.addAction(okButton)
                self.presentViewController(passwordErrorAlert, animated: true, completion: nil)
            } else if usernameTextField.text == "" || passwordTextField.text == "" {
                
                print("No Username or Password")
                let usernameandpasswordErrorAlert = UIAlertController(title: "Oops!", message: "We cant log you in because you havent input any information. Please update the username and password field and try again.", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                usernameandpasswordErrorAlert.addAction(okButton)
                self.presentViewController(usernameandpasswordErrorAlert, animated: true, completion: nil)
                
                }
            
        } else {
            let username = usernameTextField.text!.lowercaseString
            let password = passwordTextField.text!
        
            PFUser.logInWithUsernameInBackground(username, password: password) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    print("Login Succesful!")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    // The login failed. Check error to see why.
                    print("\(error?.localizedDescription)")
                    
                    let loginErrorAlert = UIAlertController(title: "Oops!", message: "We were unable to log you in. Please check your username and password and try again.", preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    loginErrorAlert.addAction(okButton)
                    self.presentViewController(loginErrorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Go to next textfield or submit when return key is touched
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            loginButtonClicked()
        }
        return true
    }
    
    func animateBackground() {
        let backgroundImage = UIImage(named:"backgroundPattern.png")!
        let amountToKeepImageSquare = backgroundImage.size.height - self.view.frame.size.height
        
        // UIImageView 1
        let backgroundImageView1 = UIImageView(image: backgroundImage)
        backgroundImageView1.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: backgroundImage.size.width - amountToKeepImageSquare, height: self.view.frame.size.height)
        self.view.addSubview(backgroundImageView1)
        
        // UIImageView 2
        let backgroundImageView2 = UIImageView(image: backgroundImage)
        backgroundImageView2.frame = CGRect(x: backgroundImageView1.frame.size.width, y: self.view.frame.origin.y, width: backgroundImage.size.width - amountToKeepImageSquare, height: self.view.frame.height)
        self.view.addSubview(backgroundImageView2)
        
        self.view.sendSubviewToBack(backgroundImageView1)
        self.view.sendSubviewToBack(backgroundImageView2)
        
        // Animate background
        UIView.animateWithDuration(15, delay: 0.0, options: [.Repeat, .CurveLinear], animations: {
            backgroundImageView1.frame = CGRectOffset(backgroundImageView1.frame, -1 * backgroundImageView1.frame.size.width, 0.0)
            backgroundImageView2.frame = CGRectOffset(backgroundImageView2.frame, -1 * backgroundImageView2.frame.size.width, 0.0)
            }, completion: nil)
    }

}