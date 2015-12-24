//
//  Message.swift
//  Drops
//
//  Created by Josh Lopez on 12/12/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

public class Message: PFObject, PFSubclassing {
    
    // MARK: - Public API
    @NSManaged public var author: PFUser! // must use PFUser
    @NSManaged public var messageText: String!
    
    // MARK: - Create new weatherUpdate
    init(author: PFUser, messageText: String) {
        super.init()
        self.author = author
        self.messageText = messageText
    }
    
//    public func report() {
//        let currentUserObjectId = User.currentUser()!.objectId!
//        if !reportedBy.contains(currentUserObjectId) {
//            reportedBy.insert(currentUserObjectId, atIndex: 0)
//            self.saveInBackground()
//        }
//    }
    
    override init()
    {
        super.init()
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
    
    public static func parseClassName() -> String {
        return "Message"
    }
}
