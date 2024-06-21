//
//  AuthBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2024/01/04.
//

import Foundation

public protocol AuthBaseCoordinator: Coordinator, CurrentCoordinated {
    
}

protocol AuthBaseCoordinated {
    var coordinator: AuthBaseCoordinator? { get }
}
