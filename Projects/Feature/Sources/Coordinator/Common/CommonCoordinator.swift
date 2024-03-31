//
//  CommonCoordinator.swift
//  Feature
//
//  Created by 이범준 on 1/13/24.
//

import UIKit

final class CommonCoordinator: CommonBaseCoordinator {
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
        case .common(let commonScene):
            moveToCommonScene(commonScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    private func moveToCommonScene(_ scene: CommonScene, userData: [String: Any]?) {
        switch scene {
        case .web:
            moveToTermsWebScene(userData)
        }
    }
    
    private func moveToTermsWebScene(_ userData: [String: Any]?) {
        guard let url = userData?["url"] as? URL else { return }
        
//        let webVC = BaseWebViewController(url: url)
//        webVC.coordinator = self
//        
//        currentNavigationViewController?.pushViewController(webVC, animated: true)
    }
}
