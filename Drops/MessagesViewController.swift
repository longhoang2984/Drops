//
//  MessagesViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/30/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit
import Parse

class MessagesViewController: UIViewController {
    
    var maxX : CGFloat = 320
    var maxY : CGFloat = 320
    let dropSize : CGFloat = 50.0
    var drops : Array<UIView> = []
    
    private var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        maxX = super.view.bounds.size.width - dropSize
        maxY = super.view.bounds.size.height / 4

        createAnimatorStuff()
        getMessages()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // get latest user data
        User.currentUser()?.fetchInBackground()
    }
    
    func getMessages() {
        
        let currentUser = User.currentUser()!
        let messagesInbox = currentUser.messagesInbox
        print(messagesInbox)
        if messagesInbox.count > 0 {
            let messagesQuery = PFQuery(className: Message.parseClassName())
            messagesQuery.whereKey("objectId", containedIn: messagesInbox)
            messagesQuery.includeKey("author")
            
            messagesQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if error == nil {
                    if let messageObjects = objects {
                        self.messages.removeAll()
                        for messageObject in messageObjects {
                            let message = messageObject as! Message
                            self.messages.append(message)
                            
                            let author = messageObject["author"] as! PFObject
                            print(author)
                        
                            let frame = self.randomFrame()
                            let color = self.randomColor()
                            let newDrop = self.addDrop(frame, color: color)
                        }
                        
                        print(self.messages)
                        print("\(self.messages.count) drops")
                    }
                } else {
                    print("\(error!.localizedDescription)")
                }
            })
            
        }

    }
    
    // random color for drop. need to replace random color with mseeage author profile pic
    func randomColor() -> UIColor {
        let red = CGFloat(CGFloat(arc4random()%100000)/100000)
        let green = CGFloat(CGFloat(arc4random()%100000)/100000)
        let blue = CGFloat(CGFloat(arc4random()%100000)/100000)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 0.85)
    }
    
    func doesNotCollide(testRect: CGRect) -> Bool {
        for drop : UIView in drops {
            let viewRect = drop.frame
            if(CGRectIntersectsRect(testRect, viewRect)) {
                return false
            }
        }
        return true
    }
    
    func randomFrame() -> CGRect {
        var guess = CGRectMake(9, 9, 9, 9)
        
        repeat {
            let guessX = CGFloat(arc4random()) % maxX
            let guessY = CGFloat(arc4random()) % maxY
            guess = CGRectMake(guessX, guessY, dropSize, dropSize)
        } while(!doesNotCollide(guess))
        
        return guess
    }
    
    // need to make drops round
    func addDrop(location: CGRect, color: UIColor) -> UIView {
        let addDrop = UIView(frame: location)
        addDrop.layer.cornerRadius = 25.0
        addDrop.layer.borderWidth = 0.0
        addDrop.clipsToBounds = true
        addDrop.backgroundColor = color
        
        view.addSubview(addDrop)
        addDropToBehaviors(addDrop)
        drops.append(addDrop)
        return addDrop
    }
    
    //----------------- UIDynamicAllocator
    
    var animator:UIDynamicAnimator? = nil
    let gravity = UIGravityBehavior()
    var collider = UICollisionBehavior()

    let itemBehavior = UIDynamicItemBehavior()
    
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view)
        
        let fromPoint = tabBarController?.tabBar.frame.origin
        let x = tabBarController?.tabBar.frame.origin.x
        let width = tabBarController?.tabBar.frame.size.width
        let toY = tabBarController?.tabBar.frame.origin.y;
        
        gravity.gravityDirection = CGVectorMake(0, 0.7)
        animator?.addBehavior(gravity)
        
        // We're bouncin' off the walls
        collider.translatesReferenceBoundsIntoBoundary = true
        collider.addBoundaryWithIdentifier("tabbar", fromPoint: fromPoint!, toPoint: CGPoint(x: x!+width!, y: toY!))
        animator?.addBehavior(collider)
        
        itemBehavior.friction = 0.2
        itemBehavior.elasticity = 0.9
        animator?.addBehavior(itemBehavior)
    }
    
    func addDropToBehaviors(drop: UIView) {
        gravity.addItem(drop)
        collider.addItem(drop)
        itemBehavior.addItem(drop)
    }
    
}