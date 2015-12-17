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
    
    private var username: String!
    private var password: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClicked() {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            print("error!")
            // Add alert to tell user what textfield is empty
            
        } else {
            let username = usernameTextField.text!
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
                    
                    let loginErrorAlert = UIAlertController(title: "Oops!", message: "Something went wrong. Check your Username and Password and try again.", preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    loginErrorAlert.addAction(okButton)
                    self.presentViewController(loginErrorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Dismisses the keyboard if touch event outside the textfield
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            loginButtonClicked()
        }
        return true
    }


}