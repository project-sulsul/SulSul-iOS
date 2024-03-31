//
//  TransferCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class TransferCoordinator: NSObject, TransferBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        return UIViewController()
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .transfer(let transferScene):
            moveTotransferScene(transferScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveTotransferScene(_ scene: TransferScene, userData: [String: Any]?) {
        switch scene {
        case .main:
            rootNavigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension TransferCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is TransferViewController else { return }
        
        let tabBarController = parentCoordinator?.rootViewController as? UITabBarController
        tabBarController?.setTabBarHidden(false)
    }
}
