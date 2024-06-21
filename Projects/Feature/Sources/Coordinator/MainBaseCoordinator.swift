//
//  MainBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

public protocol MainBaseCoordinator: Coordinator {
    var tabBarCoordinator: TabBarBaseCoordinator { get }
    var mainTabBar: UITabBarController? { get }
}

public protocol MainBaseCoordinated {
    var coordinator: MainBaseCoordinator? { get }
}
