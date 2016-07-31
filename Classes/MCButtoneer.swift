//
//  MCButtoneer.swift
//  MCButtoneer
//
//  Created by Baglan on 7/15/16.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

/// Buttoneer converts any view into a button
class MCButtoneer {
    /// Duration of the default animation
    private let animationDutation: NSTimeInterval = 0.1
    /// Alpha of the view when depressed
    private let depressedAlpha: CGFloat = 0.6
    
    /// Custom gesture recognizer to capture presses
    let gestureRecognizer = GestureRecognizer()
    
    weak var view: UIView! {
        didSet {
            // Remove gesureRecognizer from previously assigned view
            if let oldView = gestureRecognizer.view {
                oldView.removeGestureRecognizer(gestureRecognizer)
            }
            
            // Add gestureRecognizer to the new view
            if let newView = view {
                newView.addGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    init() {
        gestureRecognizer.addTarget(self, action: #selector(onGesture(_:)))
    }
    
    /**
     Convenience initializer setting both _view_ and _action_
     
     - parameter view: view to attach the buttoneer to
     - parameter action: action on tap
     */
    convenience init(view: UIView, action: ((buttoneer: MCButtoneer) -> Void)) {
        self.init()
        self.view = view
        self.action = action
    }
    
    /// Function to be executed when the button is pressed
    var onPress: ((buttoneer: MCButtoneer) -> Void)?
    /// Function to be executed when the button is released
    var onRelease: ((buttoneer: MCButtoneer) -> Void)?
    /// Function to be executed when the button is clicked
    var action: ((buttoneer: MCButtoneer) -> Void)?
    
    /// Unless *onPress* is set, this function will be called  when the button is pressed
    func defaultPress() {
        UIView.animateWithDuration(animationDutation, animations: { [unowned self] in self.view.alpha = self.depressedAlpha })
    }
    
    /// Unless *onRelease* is set, this function will be called  when the button is released
    func defaultRelease() {
        UIView.animateWithDuration(animationDutation, animations: { [unowned self] in self.view.alpha = 1 })
    }
    
    /// Unless *action* is set, this function will be called  when the button is pressed
    func defaultAction() {
        NSLog("ButtonManager.defaultAction()")
    }
    
    @objc private func onGesture(recognizer: GestureRecognizer) {
        switch(recognizer.state) {
        case .Began:
            if let onPress = onPress {
                onPress(buttoneer: self)
            } else {
                defaultPress()
            }
        case .Ended:
            if let action = action {
                action(buttoneer: self)
            } else {
                defaultAction()
            }
            fallthrough
        case .Cancelled, .Failed:
            if let onRelease = onRelease {
                onRelease(buttoneer: self)
            } else {
                defaultRelease()
            }
        default:
            break
        }
    }
    
    deinit {
        onPress = nil
        onRelease = nil
        action = nil
        view.removeGestureRecognizer(gestureRecognizer)
    }
}

extension MCButtoneer {
    class GestureRecognizer: UIGestureRecognizer {
        private var initialTouchLocation = CGPointZero
        private let maximumOffset = CGPoint(x: 20, y: 20)
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
            guard let firstTouch = touches.first else { return }
            initialTouchLocation = firstTouch.locationInView(view)
            state = .Began
        }
        
        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
            guard let firstTouch = touches.first else { return }
            let touchLocation = firstTouch.locationInView(view)
            let offset = CGPoint(x: initialTouchLocation.x - touchLocation.x, y: initialTouchLocation.y - touchLocation.y)
            if abs(offset.x) > maximumOffset.x || abs(offset.y) > maximumOffset.y {
                state = .Failed
            }
        }
        
        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
            state = .Ended
        }
        
        override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
            state = .Cancelled
        }
    }
}