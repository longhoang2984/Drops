//
//  LoginViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/7/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    private var username: String!
    private var password: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClicked() {
        
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
            }
        }
    }

}