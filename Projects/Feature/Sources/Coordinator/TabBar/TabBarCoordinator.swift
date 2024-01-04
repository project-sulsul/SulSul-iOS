//
//  TabBarCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit
import DesignSystem

enum TabType: Int {
    case home
    case benefit
    case transfer
    case transferHistory
    case more
}

final class TabBarCoordinator: NSObject, TabBarBaseCoordinator {
    var parentCoordinator: Coordinator?
    var currentFlowManager: CurrentFlowManager?
    var rootViewController: UIViewController = UITabBarController()
    
//    var commonCoordinator: CommonBaseCoordinator = CommonCoordinator()
    var authCoordinator: AuthBaseCoordinator = AuthCoordinator()
    var homeCoordinator: HomeBaseCoordinator = HomeCoordinator()
    var benefitCoordinator: BenefitBaseCoordinator = BenefitCoordinator()
    var transferCoordinator: TransferBaseCoordinator = TransferCoordinator()
    var transferHistoryCoordinator: TransferHistoryBaseCoordinator = TransferHistoryCoordinator()
    var moreCoordinator: MoreBaseCoordinator = MoreCoordinator()
    
    func start() -> UIViewController {
        let homeVC = homeCoordinator.start()
        homeCoordinator.parentCoordinator = self
        
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "tabBar_home"), selectedImage: UIImage(named: "tabBar_selectHome"))
        let benefitVC = benefitCoordinator.start()
        benefitCoordinator.parentCoordinator = self
        benefitVC.tabBarItem = UITabBarItem(title: "랭킹", image: UIImage(named: "tabBar_ranking"), selectedImage: UIImage(named: "tabBar_selectRanking"))
        
        let transferVC = transferCoordinator.start()
        transferCoordinator.parentCoordinator = self
        transferVC.tabBarItem = UITabBarItem(title: "새 피드 작성", image: UIImage(named: "tabBar_newFeed"), selectedImage: nil)
        
        let transferHistoryVC = transferHistoryCoordinator.start()
        transferHistoryCoordinator.parentCoordinator = self
        transferHistoryVC.tabBarItem = UITabBarItem(title: "피드", image: UIImage(named: "tabBar_feed"), selectedImage: UIImage(named: "tabBar_selectFeed"))
        
        let moreVC = moreCoordinator.start()
        moreCoordinator.parentCoordinator = self
        moreVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(named: "tabBar_profile"), selectedImage: UIImage(named: "tabBar_selectProfile"))
        
        let rootTabBar = rootViewController as? UITabBarController
        rootTabBar?.delegate = self
        rootTabBar?.viewControllers = [homeVC,
                                       benefitVC,
                                       transferVC,
                                       transferHistoryVC,
                                       moreVC]
        
        rootTabBar?.tabBar.tintColor = DesignSystemAsset.main.color
        rootTabBar?.tabBar.backgroundColor = DesignSystemAsset.black.color
        rootTabBar?.tabBar.layer.borderColor = UIColor.black.cgColor
        rootTabBar?.tabBar.layer.borderWidth = 1
        
        currentFlowManager = CurrentFlowManager()
        currentFlowManager?.currentCoordinator = homeCoordinator
        
        authCoordinator.parentCoordinator = self
        authCoordinator.currentFlowManager = currentFlowManager
//        
//        commonCoordinator.parentCoordinator = self
//        commonCoordinator.currentFlowManager = currentFlowManager
//        
//        moreCoordinator.parentCoordinator = self
//        moreCoordinator.currentFlowManager = currentFlowManager
        
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .home:
            startHomeFlow(tabBarFlow, userData: userData)
        case .benefit:
            startBenefitFlow(tabBarFlow, userData: userData)
        case .transfer:
            startTransferFlow(tabBarFlow, userData: userData)
        case .transferHistory:
            startTransferHistoryFlow(tabBarFlow, userData: userData)
        case .more:
            startMoreFlow(tabBarFlow, userData: userData)
//        case .auth:
//            startAuthFlow(tabBarFlow, userData: userData)
//        case .common:
//            startCommonFlow(tabBarFlow, userData: userData)
        case .auth(_):
            startAuthFlow(tabBarFlow, userData: userData)
        }
    }
    
    private func startHomeFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = homeCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.home.rawValue
        homeCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startBenefitFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = benefitCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.benefit.rawValue
        benefitCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startTransferFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = transferCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.transfer.rawValue
        transferCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startTransferHistoryFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = transferHistoryCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.transferHistory.rawValue
        transferHistoryCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startMoreFlow(_ flow: Flow, userData: [String: Any]?) {
        currentFlowManager?.currentCoordinator = moreCoordinator
        (rootViewController as? UITabBarController)?.selectedIndex = TabType.more.rawValue
        moreCoordinator.moveTo(appFlow: flow, userData: userData)
    }
    
    private func startAuthFlow(_ flow: Flow, userData: [String: Any]?) {
        authCoordinator.moveTo(appFlow: flow, userData: userData)
    }
//    
//    private func startCommonFlow(_ flow: Flow, userData: [String: Any]?) {
//        commonCoordinator.moveTo(appFlow: flow, userData: userData)
//    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if currentFlowManager?.currentCoordinator?.rootNavigationController == viewController,
           let rootViewController = (viewController as? UINavigationController)?.viewControllers.first,
           let tabBarChildViewController = rootViewController as? TabBarChildBaseCoordinated {
            tabBarChildViewController.moveToTopContent()
        }
        
        guard let tabType = TabType(rawValue: tabBarController.selectedIndex) else { return }
        
        switch tabType {
        case .home:
            currentFlowManager?.currentCoordinator = homeCoordinator
        case .benefit:
            currentFlowManager?.currentCoordinator = benefitCoordinator
        case .transfer:
            currentFlowManager?.currentCoordinator = transferCoordinator
        case .transferHistory:
            currentFlowManager?.currentCoordinator = transferHistoryCoordinator
        case .more:
            currentFlowManager?.currentCoordinator = moreCoordinator
        }
    }
}
