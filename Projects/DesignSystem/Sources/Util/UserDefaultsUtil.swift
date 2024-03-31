//
//  UserDefaultsUtil.swift
//  DesignSystem
//
//  Created by 김유진 on 2024/01/11.
//

import Foundation

public enum Key: String {
    case recentKeyword
}

public struct UserDefaultsUtil {
    public static let shared = UserDefaultsUtil()
    
    public func setRecentKeywordList(_ dataList: [String]) {
        set(dataList, key: .recentKeyword)
    }
    
    public func recentKeywordList() -> [String]? {
        get(.recentKeyword) as? [String]
    }
    
    // MARK: 데이터 set, get 함수
    private func set(_ data: Any, key: Key) {
        UserDefaults.standard.setValue(data, forKey: key.rawValue)
    }
    
    private func get(_ key: Key) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    public func remove(key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
