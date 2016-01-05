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
    
    var backgroundImage:UIImage!
    
    var backgroundImageView1:UIImageView!
    var backgroundImageView2:UIImageView!

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
            
            controller.addAction(ImageAction(title: NSLocalizedString("Photo Library", comment: "ActionTitle"),
                secondaryTitle: NSLocalizedString("Use this one", comment: "Action Title"),
                handler: { (_) -> () in
                    
                    self.presentPhotoLibrary()
                    
                }, secondaryHandler: { (action, numberOfPhotos) -> () in
                    controller.getSelectedImagesWithCompletion({ (images) -> Void in
                        self.profileImage = images[0]
                        self.userProfileImageView.image = self.profileImage
                    })
            }))
            
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
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func presentPhotoLibrary()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func presentCamera() {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraDevice = .Front
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func signUpButtonClicked() {
        if userProfileImageView.image == nil {
            print("no profile image")
        } else {
            let username = usernameTextField.text!.lowercaseString
            let password = passwordTextField.text!
            let email = emailTextField.text!.lowercaseString
            let profileText = userProfileTextField.text!
            
            let newUser = User(username: username, password: password, email: email, image: profileImage, profileText: profileText, messagesInbox: [])
            newUser.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                if error == nil {
                    
                    print("register success!")
                    let postSuccessAlert = UIAlertController(title: "Welcome \(username)!", message: "Your profile has been created! :)", preferredStyle: .Alert)
                    let okButton = UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction!) -> () in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FirstViewController") as UIViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    postSuccessAlert.addAction(okButton)
                    self.presentViewController(postSuccessAlert, animated: true, completion: nil)
                    
                } else {
                    print("\(error?.localizedDescription)")
                }
            })
        }
    }
    
    @IBAction func closeButtonClicked() {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
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

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dispatch_async(dispatch_get_main_queue(), {
            picker.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.userProfileImageView.image! = self.profileImage
        userProfileImageView.contentMode = .ScaleAspectFill
        userProfileImageView.layer.cornerRadius = 25.0
        userProfileImageView.layer.borderWidth = 0.0
        userProfileImageView.clipsToBounds = true
        
        dispatch_async(dispatch_get_main_queue(), {
            picker.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}
