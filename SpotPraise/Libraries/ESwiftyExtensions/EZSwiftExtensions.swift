//
//  File.swift
//  ArabLife
//
//  Created by OSX on 11/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

import Foundation
import UIKit

public struct ez {
    
    /// EZSE: Runs function after x seconds
    public static func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
        runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
    }
    
    /// EZSE: Runs function after x seconds with dispatch_queue, use this syntax: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
    public static func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
    
    
    /// EZSE: Submits a block for asynchronous execution on the main queue
    public static func runThisInMainThread(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    /// EZSE: Runs the function after x seconds
    public static func dispatchDelay(_ second: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(second * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    /// EZSE: Returns the top ViewController
    //        public static var topMostVC: UIViewController? {
    //
    //            let topVC = UIApplication.shared.inputViewController
    //            if topVC == nil {
    //                print("EZSwiftExtensions Error: You don't have any views set. You may be calling them in viewDidLoad. Try viewDidAppear instead.")
    //            }
    //            return topVC
    //        }
    
}

 


// MARK: Gesture Extensions
extension UIView {
    
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    //
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    /// EZSwiftExtensions
    public func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, target: AnyObject, action: Selector) {
        let swipe = UISwipeGestureRecognizer(target: target, action: action)
        swipe.direction = direction
        
        #if os(iOS)
        
        swipe.numberOfTouchesRequired = numberOfTouches
        
        #endif
        
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }
    
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, action: ((UISwipeGestureRecognizer) -> Void)?) {
        let swipe = BlockSwipe(direction: direction, fingerCount: numberOfTouches, action: action)
        addGestureRecognizer(swipe)
        isUserInteractionEnabled = true
    }
    
    //    /// EZSwiftExtensions
    //    public func addPanGesture(target: AnyObject, action: Selector) {
    //        let pan = UIPanGestureRecognizer(target: target, action: action)
    //        addGestureRecognizer(pan)
    //        isUserInteractionEnabled = true
    //    }
    //
    /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    public func addPanGesture(action: ((UIPanGestureRecognizer) -> Void)?) {
        let pan = BlockPan(action: action)
        addGestureRecognizer(pan)
        isUserInteractionEnabled = true
    }
    //
    //    #if os(iOS)
    //
    //    /// EZSwiftExtensions
    //    public func addPinchGesture(target: AnyObject, action: Selector) {
    //        let pinch = UIPinchGestureRecognizer(target: target, action: action)
    //        addGestureRecognizer(pinch)
    //        isUserInteractionEnabled = true
    //    }
    //
    //    #endif
    //
    //    #if os(iOS)
    //
    //
    //
    //    #endif
    //
        /// EZSwiftExtensions
        public func addLongPressGesture(target: AnyObject, action: Selector) {
            let longPress = UILongPressGestureRecognizer(target: target, action: action)
            addGestureRecognizer(longPress)
            isUserInteractionEnabled = true
        }
    
        /// EZSwiftExtensions - Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
        public func addLongPressGesture(action: ((UILongPressGestureRecognizer) -> Void)?) {
            let longPress = BlockLongPress(action: action)
            addGestureRecognizer(longPress)
            isUserInteractionEnabled = true
        }

    ///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    open class BlockPan: UIPanGestureRecognizer {
        private var panAction: ((UIPanGestureRecognizer) -> Void)?
        
        public override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
        }
        
        public convenience init (action: ((UIPanGestureRecognizer) -> Void)?) {
            self.init()
            self.panAction = action
            self.addTarget(self, action: #selector(BlockPan.didPan(_:)))
        }
        
        @objc open func didPan (_ pan: UIPanGestureRecognizer) {
            panAction? (pan)
        }
    }

    open class BlockLongPress: UILongPressGestureRecognizer {
        private var longPressAction: ((UILongPressGestureRecognizer) -> Void)?
    
        public override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
        }
    
        public convenience init (action: ((UILongPressGestureRecognizer) -> Void)?) {
            self.init()
            longPressAction = action
            addTarget(self, action: #selector(BlockLongPress.didLongPressed(_:)))
        }
    
        @objc open func didLongPressed(_ longPress: UILongPressGestureRecognizer) {
            if longPress.state == UIGestureRecognizer.State.began {
                longPressAction?(longPress)
            }
        }
    }

    open class BlockSwipe: UISwipeGestureRecognizer {
        
        private var swipeAction: ((UISwipeGestureRecognizer) -> Void)?
        
        public override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
        }
        
        public convenience init (direction: UISwipeGestureRecognizer.Direction,
                                 fingerCount: Int = 1,
                                 action: ((UISwipeGestureRecognizer) -> Void)?) {
            self.init()
            self.direction = direction
            
            #if os(iOS)
            
            numberOfTouchesRequired = fingerCount
            
            #endif
            
            swipeAction = action
            addTarget(self, action: #selector(BlockSwipe.didSwipe(_:)))
        }
        
        @objc open func didSwipe (_ swipe: UISwipeGestureRecognizer) {
            swipeAction? (swipe)
        }
    }
    
    
    //
    //  BlockTap.swift
    //
    //
    //  Created by Cem Olcay on 12/08/15.
    //
    //
    
    
    
    ///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    open class BlockTap: UITapGestureRecognizer {
        private var tapAction: ((UITapGestureRecognizer) -> Void)?
        
        public override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
        }
        
        public convenience init (
            tapCount: Int = 1,
            fingerCount: Int = 1,
            action: ((UITapGestureRecognizer) -> Void)?) {
            self.init()
            self.numberOfTapsRequired = tapCount
            
            
            //            self.numberOfTouchesRequired = fingerCount
            
            
            self.tapAction = action
            self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
        }
        
        @objc open func didTap(_ tap: UITapGestureRecognizer) {
            tapAction? (tap)
        }
    }
    
}
