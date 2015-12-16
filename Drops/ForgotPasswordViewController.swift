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
    
    private var email: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
