//
//  User.swift
//  Drops
//
//  Created by Josh Lopez on 12/11/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

public class User: PFUser {
    
    // MARK: - Public API
    @NSManaged public var profileImageFile: PFFile!
    @NSManaged public var profileText: String
    @NSManaged public var createdMessages: [String]!
    @NSManaged public var messagesInbox: [String]!
    @NSManaged public var weatherUpdates: [String]!
    
    // Create new user
    init(username: String, password: String, email: String, image: UIImage, profileText: String)
    {
        super.init()
        
        let imageFile = createFileFrom(image)
        
        self.profileImageFile = imageFile
        self.username = username
        self.email = email
        self.password = password
        self.profileText = profileText
    }
    
    
    // MARK: - PFSubclassing
    override public class func initialize() {
        
        struct Static {
            static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
}