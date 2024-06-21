//
//  HiddenTabBarBaseViewController.swift
//  DesignSystem
//
//  Created by 이범준 on 5/1/24.
//

import Foundation

open class HiddenTabBarBaseViewController: BaseViewController {
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
