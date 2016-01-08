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
    let boxSize : CGFloat = 50.0
    var boxes : Array<UIView> = []
    
    var messageCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        maxX = super.view.bounds.size.width - boxSize
        maxY = super.view.bounds.size.height - boxSize

        createAnimatorStuff()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // get latest user data
        PFUser.currentUser()?.fetchInBackground()
    }
    
    func getMessages() {
        let currentUser = PFUser.currentUser()
        let messagesInbox = currentUser!["messagesInbox"]
        
        let query = PFQuery(className: "Message")
        query.whereKey("objectId", containedIn: (messagesInbox as? [PFObject])!)
        query.includeKey("author")
        query.findObjectsInBackgroundWithBlock {
            (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {

                self.messageCount = (results?.count)!
                print(results)

                // let userDataQuery = PFQuery(className: "User")
                // userDataQuery.whereKey(<#T##key: String##String#>, containedIn: <#T##[AnyObject]#>)
                
                print("\(self.messageCount) boxes")
                for i in 0..<self.messageCount {
                    let frame = self.randomFrame()
                    let color = self.randomColor()
                    let newBox = self.addBox(frame, color: color)
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getMessages()
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat(CGFloat(arc4random()%100000)/100000)
        let green = CGFloat(CGFloat(arc4random()%100000)/100000)
        let blue = CGFloat(CGFloat(arc4random()%100000)/100000)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 0.85)
    }
    
    func doesNotCollide(testRect: CGRect) -> Bool {
        for box : UIView in boxes {
            let viewRect = box.frame
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
            guess = CGRectMake(guessX, guessY, boxSize, boxSize)
        } while(!doesNotCollide(guess))
        
        return guess
    }
    
    func addBox(location: CGRect, color: UIColor) -> UIView {
        let newBox = UIView(frame: location)
        newBox.layer.cornerRadius = 25.0
        newBox.layer.borderWidth = 0.0
        newBox.clipsToBounds = true
        newBox.backgroundColor = color
        
        view.addSubview(newBox)
        addBoxToBehaviors(newBox)
        boxes.append(newBox)
        return newBox
    }
    
//    func generateBoxes() {
//        print("\(self.messageCount) boxes")
//        for i in 0..<messageCount {
//            let frame = randomFrame()
//            let color = randomColor()
//            let newBox = addBox(frame, color: color)
//        }
//    }
    
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
    
    func addBoxToBehaviors(box: UIView) {
        gravity.addItem(box)
        collider.addItem(box)
        itemBehavior.addItem(box)
    }
    
}