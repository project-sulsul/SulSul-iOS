//
//  MoreBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import Foundation

public protocol MoreBaseCoordinator: Coordinator, CurrentCoordinated {}

protocol MoreBaseCoordinated {
    var coordinator: MoreBaseCoordinator? { get }
}
