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
    fileprivate let animationDutation: TimeInterval = 0.1
    /// Alpha of the view when depressed
    fileprivate let depressedAlpha: CGFloat = 0.6
    
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
     
     **Note:** does not, currently, work!
     */
    convenience init(view: UIView, action: @escaping ((_ buttoneer: MCButtoneer) -> Void)) {
        self.init()
        self.view = view
        self.action = action
        
        // TODO: Why doesn't it work?!
    }
    
    /// Function to be executed when the button is pressed
    var onPress: ((_ buttoneer: MCButtoneer) -> Void)?
    /// Function to be executed when the button is released
    var onRelease: ((_ buttoneer: MCButtoneer) -> Void)?
    /// Function to be executed when the button is clicked
    var action: ((_ buttoneer: MCButtoneer) -> Void)?
    
    /// Unless *onPress* is set, this function will be called  when the button is pressed
    func defaultPress() {
        UIView.animate(withDuration: animationDutation, animations: { [unowned self] in self.view.alpha = self.depressedAlpha })
    }
    
    /// Unless *onRelease* is set, this function will be called  when the button is released
    func defaultRelease() {
        UIView.animate(withDuration: animationDutation, animations: { [unowned self] in self.view.alpha = 1 })
    }
    
    /// Unless *action* is set, this function will be called  when the button is pressed
    func defaultAction() {
        NSLog("ButtonManager.defaultAction()")
    }
    
    @objc fileprivate func onGesture(_ recognizer: GestureRecognizer) {
        switch(recognizer.state) {
        case .began:
            if let onPress = onPress {
                onPress(self)
            } else {
                defaultPress()
            }
        case .ended:
            if let action = action {
                action(self)
            } else {
                defaultAction()
            }
            fallthrough
        case .cancelled, .failed:
            if let onRelease = onRelease {
                onRelease(self)
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
        gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
    }
}

extension MCButtoneer {
    class GestureRecognizer: UIGestureRecognizer {
        fileprivate var initialTouchLocation = CGPoint.zero
        fileprivate let maximumOffset = CGPoint(x: 20, y: 20)
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            guard let firstTouch = touches.first, let window = view?.window else { return }
            initialTouchLocation = firstTouch.location(in: window)
            state = .began
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
            guard let firstTouch = touches.first, let window = view?.window else { return }
            let touchLocation = firstTouch.location(in: window)
            let offset = CGPoint(x: initialTouchLocation.x - touchLocation.x, y: initialTouchLocation.y - touchLocation.y)
            if abs(offset.x) > maximumOffset.x || abs(offset.y) > maximumOffset.y {
                state = .failed
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
            state = .ended
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
            state = .cancelled
        }
        
        // MARK: - The following is so that it both cannot be prevented and cannot prevent, say, UIScrollView 
        
        override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }
        
        override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }
    }
}
