//
//  BenefitBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import Foundation

public protocol BenefitBaseCoordinator: Coordinator, CurrentCoordinated {}

protocol BenefitBaseCoordinated {
    var coordinator: BenefitBaseCoordinator? { get }
}
