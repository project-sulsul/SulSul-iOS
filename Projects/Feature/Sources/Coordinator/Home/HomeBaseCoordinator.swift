//
//  HomeBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import Foundation

public protocol HomeBaseCoordinator: Coordinator {}

protocol HomeBaseCoordinated {
    var coordinator: HomeBaseCoordinator? { get }
}
