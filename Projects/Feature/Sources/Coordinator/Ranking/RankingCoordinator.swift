//
//  RankingCoordinator.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-03.
//

import UIKit

final class RankingCoordinator: NSObject, RankingBaseCoordinator {
    var currentFlowManager: CurrentFlowManager?
    
    var parentCoordinator: Coordinator?
    var rootViewController: UIViewController = UIViewController()
    
    func start() -> UIViewController {
        let viewModel = RankingMainViewModel()
        let viewController = RankingMainViewController(viewModel: viewModel)
        
        viewController.coordinator = self
        rootViewController = UINavigationController(rootViewController: viewController)
        return rootViewController
    }
    
    func moveTo(appFlow: Flow, userData: [String: Any]?) {
        guard let tabBarFlow = appFlow.tabBarFlow else {
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
            return
        }
        
        switch tabBarFlow {
        case .ranking(let rankingScene):
            moveToRankingScene(rankingScene, userData: userData)
        default:
            parentCoordinator?.moveTo(appFlow: appFlow, userData: userData)
        }
    }
    
    func moveToRankingScene(_ scene: RankingScene, userData: [String: Any]?) {
        switch scene {
        case .main:
            rootNavigationController?.popToRootViewController(animated: true)
        case .search: return
        case .alarm:
            guard let feedId = userData?["feedId"] as? Int else { return }
            
            let viewModel = DetailFeedViewModel(feedID: feedId)
            let viewController = DetailFeedViewController(viewModel: viewModel)
            currentNavigationViewController?.pushViewController(viewController, animated: true)
        case .detailDrink: return
//            let detailDrinkVC = DetailDrinkViewController()
//            detailDrinkVC.coordinator = self
//            
//            currentNavigationViewController?.pushViewController(detailDrinkVC, animated: true)
        case .detailCombination: return
//            let detailCombinationVC = DetailCombinationViewController()
//            detailCombinationVC.coordinator = self
//            
//            currentNavigationViewController?.pushViewController(detailCombinationVC, animated: true)
        }
    }
}

// MARK: - UINavigationController Delegate

extension RankingCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        guard viewController is RankingMainViewController else { return }
        
        let tabBarController = parentCoordinator?.rootViewController as? UITabBarController
        tabBarController?.setTabBarHidden(false)
    }
}
