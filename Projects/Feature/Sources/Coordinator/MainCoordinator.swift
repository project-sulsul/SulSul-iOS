//
//  MainCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

public final class MainCoordinator: MainBaseCoordinator {
    public var tabBarCoordinator: TabBarBaseCoordinator = TabBarCoordinator()
    public var mainTabBar: UITabBarController?
    public var parentCoordinator: Coordinator?
    public var rootViewController: UIViewController = UIViewController()
    
    public init() {
        
    }
    public func start() -> UIViewController {
        tabBarCoordinator.parentCoordinator = self
        mainTabBar = tabBarCoordinator.start() as? UITabBarController
        let viewModel = SplashViewModel()
        let splashVC = SplashViewController(viewModel: viewModel)
        splashVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: splashVC)
        rootViewController.hidesBottomBarWhenPushed = true
        
        let navigation = rootViewController as? UINavigationController
        navigation?.isNavigationBarHidden = true
        return rootViewController
    }
    
    public func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let flow = appFlow.appFlow else { return }
        
        switch flow {
        case .tabBar(let tabBarFlow):
            startTabBarFlow(tabBarFlow, userData: userData)
        }
    }
    
    private func startIntroFlow(userData: [String: Any]?) {
        let introVC = IntroViewController()
        introVC.coordinator = self
        rootNavigationController?.pushViewController(introVC, animated: false)
    }
    
    private func startTabBarFlow(_ tabBarFlow: TabBarFlow, userData: [String: Any]?) {
        guard let mainTabBar = self.mainTabBar else { return }
        
        if rootNavigationController?.viewControllers.first is UITabBarController == false {
            rootNavigationController?.viewControllers.removeAll()
            rootNavigationController?.pushViewController(mainTabBar, animated: false)
        }
        
        tabBarCoordinator.moveTo(appFlow: tabBarFlow, userData: userData)
    }
}
