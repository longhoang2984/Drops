//
//  MessagesViewController.swift
//  Drops
//
//  Created by Josh Lopez on 12/30/15.
//  Copyright © 2015 Josh Lopez. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
    
    @IBOutlet var animatorView: UIView!
    
    var maxX : CGFloat = 320
    var maxY : CGFloat = 320
    let boxSize : CGFloat = 30.0
    var boxes : Array<UIView> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maxX = super.view.bounds.size.width - boxSize
        maxY = super.view.bounds.size.height - boxSize
        // Do any additional setup after loading the view, typically from a nib.
        createAnimatorStuff()
        generateBoxes()
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
        newBox.backgroundColor = color
        
        view.addSubview(newBox)
        addBoxToBehaviors(newBox)
        boxes.append(newBox)
        return newBox
    }
    
    func generateBoxes() {
        for i in 0..<10 {
            let frame = randomFrame()
            let color = randomColor()
            let newBox = addBox(frame, color: color)
        }
    }
    
    //----------------- UIDynamicAllocator
    
    var animator:UIDynamicAnimator? = nil
    let gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()

    let itemBehavior = UIDynamicItemBehavior()
    
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view)
        
        gravity.gravityDirection = CGVectorMake(0, 0.8)
        animator?.addBehavior(gravity)
        
        // We're bouncin' off the walls
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        itemBehavior.friction = 0.1
        itemBehavior.elasticity = 0.9
        animator?.addBehavior(itemBehavior)
        
        
    }
    
    func addBoxToBehaviors(box: UIView) {
        gravity.addItem(box)
        collider.addItem(box)
        itemBehavior.addItem(box)
    }
    
}