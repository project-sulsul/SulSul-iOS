//
//  MoreCoodinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class MoreCoordinator: NSObject, MoreBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let moreVC = ProfileMainViewController()
        moreVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: moreVC)
        rootNavigationController?.delegate = self
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .more(let profileScene):
            moveToProfileScene(profileScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveToProfileScene(_ scene: ProfileScene, userData: [String: Any]?) {
        switch scene {
        case .main:
//            let profileViewModel = ProfileViewModel()
            let profileMainVC = ProfileMainViewController()
            profileMainVC.coordinator = self
            currentNavigationViewController?.interactivePopGestureRecognizer?.isEnabled = true
            currentNavigationViewController?.pushViewController(profileMainVC, animated: true)
        case .profileSetting:
            let profileSettingVC = ProfileSettingViewController()
            profileSettingVC.coordinator = self
            currentNavigationViewController?.interactivePopGestureRecognizer?.isEnabled = true
            currentNavigationViewController?.pushViewController(profileSettingVC, animated: true)
        case .profileEdit:
            let profileEditVC = ProfileEditViewController()
            profileEditVC.coordinator = self
            currentNavigationViewController?.interactivePopGestureRecognizer?.isEnabled = true
            currentNavigationViewController?.pushViewController(profileEditVC, animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension MoreCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is ProfileMainViewController else { return }
        
        let tabBarController = parentCoordinator?.rootViewController as? UITabBarController
        tabBarController?.setTabBarHidden(false)
    }
}
