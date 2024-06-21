//
//  StaticValues.swift
//  Feature
//
//  Created by 이범준 on 3/23/24.
//

import Foundation
import Combine

struct StaticValues {
    static var isLoggedIn = CurrentValueSubject<Bool, Never>(false)
    static var isFirstLaunch: Bool = true
    static var drinkPairings: [SnackModel] = []
    static var snackPairings: [SnackModel] = []
    
    static func getDrinkPairingById(_ id: Int) -> SnackModel? {
        return drinkPairings.first { $0.id == id }
    }
    
    static func getSnackPairingById(_ id: Int) -> SnackModel? {
        return snackPairings.first { $0.id == id }
    }
    
    static func isLoggedInPublisher() -> AnyPublisher<Bool, Never> {
        return isLoggedIn.eraseToAnyPublisher()
    }
}
