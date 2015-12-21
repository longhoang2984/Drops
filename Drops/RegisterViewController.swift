//
//  RegisterViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/7/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Photos

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userProfileTextField: UITextField!
    @IBOutlet var formView: UIView!
    @IBOutlet var registerButton: UIButton!
    
    private var profileImage: UIImage!
    private var username: String!
    private var email: String!
    private var password: String!
    private var profileText: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        userProfileTextField.delegate = self
        
        // Round the corners of the transparent formview
        self.formView.layer.cornerRadius = 10
        self.formView.clipsToBounds = true;
        
        // Round the corners of the registerButton
        self.registerButton.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pickProfileImage(tap: UITapGestureRecognizer)
    {
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .NotDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.pickProfileImage(tap)
                })
            })
            return
        }
        
        if authorization == .Authorized {
            let controller = ImagePickerSheetController()
            
            controller.addAction(ImageAction(title: NSLocalizedString("Take a Photo", comment: "ActionTitle"),
                secondaryTitle: NSLocalizedString("Use this one", comment: "Action Title"),
                handler: { (_) -> () in
                    
                    self.presentCamera()
                    
                }, secondaryHandler: { (action, numberOfPhotos) -> () in
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.profileImage = images[0]
                        self.userProfileImageView.image = self.profileImage
                    })
            }))
            
            controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: nil, secondaryHandler: nil))
            
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func presentCamera()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func signUpButtonClicked()
    {
        if userProfileImageView.image == nil {
            print("no profile image")
        } else {
            let username = usernameTextField.text!.lowercaseString
            let password = passwordTextField.text!
            let email = emailTextField.text!.lowercaseString
            let profileText = userProfileTextField.text!
            
            let newUser = User(username: username, password: password, email: email, image: profileImage, profileText: profileText)
            newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    print("register success!")
                } else {
                    print("\(error?.localizedDescription)")
                    print(username)
                    print(self.password)
                    print(self.email)
                    print(self.profileImage)
                    print(profileText)
                }
            })
        }
    }
    
    @IBAction func closeButtonClicked()
    {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    // Dismisses the keyboard if touch event outside the textfield
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    // Go to next textfield or submit when return key is touched
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField == self.usernameTextField {
            self.emailTextField.becomeFirstResponder()
            
        } else if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
            
        } else if textField == self.passwordTextField {
            self.userProfileTextField.becomeFirstResponder()
            
        } else if textField == self.userProfileTextField {
            signUpButtonClicked()
        }
        return true
    }


}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        self.profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.userProfileImageView.image! = self.profileImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
