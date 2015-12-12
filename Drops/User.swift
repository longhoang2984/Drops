//
//  User.swift
//  Drops
//
//  Created by Josh Lopez on 12/11/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse



public class User: PFUser
{
    @NSManaged public var profileImageFile: PFFile!
    
    init(username: String, password: String, email: String, image: UIImage, bio: String)
    {
        super.init()
        
        let imageFile = image.createPFFile()
        
        self.profileImageFile = imageFile
        self.username = username
        self.password = password
        self.email = email
        self.bio = bio
    }
    
    override init()
    {
        super.init()
    }
    
    override public class func initialize()
    {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}