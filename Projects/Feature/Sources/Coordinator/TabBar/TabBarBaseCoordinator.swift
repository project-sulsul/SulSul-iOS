//
//  TabBarBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit

public final class CurrentFlowManager {
    var currentCoordinator: Coordinator?
}

public protocol CurrentCoordinated {
    var currentFlowManager: CurrentFlowManager? { get set }
}

public extension CurrentCoordinated {
    public var currentNavigationViewController: UINavigationController? {
        get {
            (currentFlowManager?.currentCoordinator?.rootViewController as? UINavigationController)
        }
    }
}

public protocol TabBarBaseCoordinator: Coordinator, CurrentCoordinated {
    var commonCoordinator: CommonBaseCoordinator { get }
    var authCoordinator: AuthBaseCoordinator { get }
    var homeCoordinator: HomeBaseCoordinator { get }
    var benefitCoordinator: BenefitBaseCoordinator { get }
    var transferCoordinator: TransferBaseCoordinator { get }
    var transferHistoryCoordinator: TransferHistoryBaseCoordinator { get }
    var moreCoordinator: MoreBaseCoordinator { get }
}

protocol TabBarChildBaseCoordinated {
    func moveToTopContent()
}

