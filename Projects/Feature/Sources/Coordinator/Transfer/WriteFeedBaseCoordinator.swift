//
//  WriteFeedBaseCoordinator.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import Foundation

public protocol WriteFeedBaseCoordinator: Coordinator, CurrentCoordinated {}

protocol WriteFeedBaseCoordinated {
    var coordinator: WriteFeedBaseCoordinator? { get }
}
