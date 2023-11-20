//
//  UIView+Extension.swift
//  DesignSystem
//
//  Created by 이범준 on 2023/08/24.
//

import UIKit

public extension UIView {
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
