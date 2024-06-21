//
//  RankingBaseCoordinator.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-03.
//

import Foundation

public protocol RankingBaseCoordinator: Coordinator, CurrentCoordinated {}

protocol RankingBaseCoordinated {
    var coordinator: RankingBaseCoordinator? { get }
}
