//
//  transferHistoryCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class TransferHistoryCoordinator: NSObject, TransferHistoryBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {

        let transferHistoryVC = RamdomFeedViewController()
        transferHistoryVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: transferHistoryVC)
        rootNavigationController?.delegate = self
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .transferHistory(let transferHistoryScene):
            moveTotransferHistoryScene(transferHistoryScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveTotransferHistoryScene(_ scene: TransferHistoryScene, userData: [String: Any]?) {
        switch scene {
        case .main:
            rootNavigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension TransferHistoryCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is RamdomFeedViewController else { return }
        
        let tabBarController = parentCoordinator?.rootViewController as? UITabBarController
        tabBarController?.setTabBarHidden(false)
    }
}
