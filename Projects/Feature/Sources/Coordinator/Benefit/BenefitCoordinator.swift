//
//  BenefitCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

final class BenefitCoordinator: NSObject, BenefitBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {

        let benefitVC = BenefitViewController()
        benefitVC.coordinator = self
        rootViewController = UINavigationController(rootViewController: benefitVC)
        rootNavigationController?.delegate = self
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .benefit(let benefitScene):
            moveToBenefitScene(benefitScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveToBenefitScene(_ scene: BenefitScene, userData: [String: Any]?) {
        switch scene {
        case .main:
            rootNavigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension BenefitCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewController is BenefitViewController else { return }
        
        let tabBarController = parentCoordinator?.rootViewController as? UITabBarController
        tabBarController?.setTabBarHidden(false)
    }
}
