//
//  WeatherUpdate.swift
//  Drops
//
//  Created by Josh Lopez on 12/12/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

public class WeatherUpdate: PFObject, PFSubclassing {
    
    // MARK: - Public API
    @NSManaged public var user: PFUser // must use PFUser
    @NSManaged public var currentWeather: Int
    
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
        return "WeatherUpdate"
    }
}
