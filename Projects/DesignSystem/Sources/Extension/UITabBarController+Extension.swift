//
//  UITabBarController+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 2024/01/18.
//

import UIKit

extension UITabBarController {
    public func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        let tabBarHeight: CGFloat = tabBar.frame.size.height
        let tabBarPositionY: CGFloat = UIScreen.main.bounds.height - (hidden ? 0 : tabBarHeight)
        
        guard animated else {
            tabBar.frame.origin.y = tabBarPositionY
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.tabBar.frame.origin.y = tabBarPositionY
        }
    }
}
