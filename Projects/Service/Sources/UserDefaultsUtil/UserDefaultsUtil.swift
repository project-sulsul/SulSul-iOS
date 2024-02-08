//
//  UserDefaultsUtil.swift
//  Service
//
//  Created by 이범준 on 2024/01/29.
//

import Foundation

public struct UserDefaultsUtil {
    public static let shared = UserDefaultsUtil()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    public enum UserDefaultKey: String {
        case userId
    }
    
    public func setUserId(_ id: Int) {
        defaults.setValue(id, forKey: UserDefaultKey.userId.rawValue)
    }
    
    public func getInstallationId() -> Int {
        return defaults.value(forKey: UserDefaultKey.userId.rawValue) as? Int ?? 0
    }
}