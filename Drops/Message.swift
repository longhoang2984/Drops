//
//  Message.swift
//  Drops
//
//  Created by Josh Lopez on 12/11/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

public class Message:PFObject, PFSubclassing
{
   // MARK: - Public API
    @NSManaged public var messageId: String!
    @NSManaged public var messageAuthor: PFUser!
}
