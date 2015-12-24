//
//  MessageViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/20/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class MessageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var formView: UIView!
    @IBOutlet var messageButton: UIButton!
    
    private var messageText: String?
    
    let user = PFUser.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        
        // Round the corners of the transparent formview
        self.formView.layer.cornerRadius = 10
        self.formView.clipsToBounds = true;
        
        // Round the corners of the registerButton
        self.messageButton.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageButtonClicked() {
        
        let messageText = messageTextField.text!
        let newMessage = Message(author: user!, messageText: messageText)
        newMessage.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                print("Post Drop to parse successful")
                
                let relation = self.user!.relationForKey("createdMessages")
                relation.addObject(newMessage)
                self.user!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The post has been added to the user's likes relation.
                    } else {
                        // There was a problem, check error.description
                    }
                }

                
                let postSuccessAlert = UIAlertController(title: "Success!", message: "Your drop has been added! Thank you so much!", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) -> () in
                    self.dismissViewControllerAnimated(true, completion: {});
                })
                
                postSuccessAlert.addAction(okButton)
                self.presentViewController(postSuccessAlert, animated: true, completion: nil)
                
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
    }

    
    @IBAction func closeButtonClicked()
    {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    // Go to next textfield or submit when return key is touched
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.messageTextField {
            self.view.endEditing(true)
            messageButtonClicked()
        }
        return true
    }

}
