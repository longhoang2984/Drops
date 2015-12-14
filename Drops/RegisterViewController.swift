//
//  RegisterViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/7/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Photos

class RegisterViewController: UIViewController {
    
    @IBOutlet var userProfileImageView: UIImageView!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userProfileTextField: UITextView!
    
    private var profileImage: UIImage!
    private var username: String!
    private var email: String!
    private var password: String!
    private var profileText: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameTextField.becomeFirstResponder()
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
            
            controller.addAction(ImageAction(title: NSLocalizedString("Take Photo or Video", comment: "ActionTitle"),
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
        // CHALLENGE: present normla image picker controller
        //              update the postImage + postImageView
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
            let username = usernameTextField.text!
            let newUser = User(username: username, password: password, email: email, image: profileImage)
            newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("\(error?.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func backButtonClicked()
    {
        self.navigationController?.popViewControllerAnimated(true)
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
