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
        let viewModel = ProfileMainViewModel()
        let profileMainVC = ProfileMainViewController(viewModel: viewModel)
        profileMainVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: profileMainVC)
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
            rootNavigationController?.popToRootViewController(animated: true)
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
        case .selectDrink:
            let viewModel = SelectDrinkViewModel()
            let selectDrinkVC = SelectDrinkViewController(viewModel: viewModel)
            selectDrinkVC.coordinator = self
            currentNavigationViewController?.pushViewController(selectDrinkVC, animated: false)
        case .selectSnack:
            let viewModel = SelectSnackViewModel()
            let selectDrinkVC = SelectSnackViewController(viewModel: viewModel)
            selectDrinkVC.coordinator = self
            currentNavigationViewController?.pushViewController(selectDrinkVC, animated: false)
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
