//
//  CommonBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 1/13/24.
//

import Foundation

public protocol CommonBaseCoordinator: Coordinator, CurrentCoordinated {}

protocol CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator? { get }
}
