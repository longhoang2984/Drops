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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round the corners of the transparent formview
        self.formView.layer.cornerRadius = 10
        self.formView.clipsToBounds = true;
        
        // Round the corners of the registerButton
        self.newPasswordButton.layer.cornerRadius = 5
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
    
    // Go to next textfield or submit when return key is touched
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.emailTextField {
            self.view.endEditing(true)
            passwordResetButtonClicked()
        }
        return true
    }

}
