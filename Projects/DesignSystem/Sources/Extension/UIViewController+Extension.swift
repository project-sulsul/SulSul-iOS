//
//  UIViewController + Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/08/24.
//

import UIKit

public extension UIViewController {
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    // https://www.advancedswift.com/animate-with-ios-keyboard-swift/
    func animateWithKeyboard(notification: NSNotification,
                             animations: ((_ keyboardFrame: CGRect) -> Void)?,
                             completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        // Extract the duration of the keyboard animation
        let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
        
        // Extract the final frame of the keyboard
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        
        // Extract the curve of the iOS keyboard animation
        let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
        
        guard let duration = notification.userInfo?[durationKey] as? Double,
              let keyboardFrameValue = notification.userInfo?[frameKey] as? NSValue,
              let curveValue = notification.userInfo?[curveKey] as? Int,
              let curve = UIView.AnimationCurve(rawValue: curveValue) else {
            return
        }
        
        // Create a property animator to manage the animation
        let animator = UIViewPropertyAnimator(duration: duration, curve: curve) { [weak self] in
            // Perform the necessary animation layout updates
            animations?(keyboardFrameValue.cgRectValue)
            
            // Required to trigger NSLayoutConstraint changes
            // to animate
            self?.view.layoutIfNeeded()
        }
        
        if let completion = completion {
            animator.addCompletion(completion)
        }
        
        // Start the animation
        animator.startAnimation()
    }
}
