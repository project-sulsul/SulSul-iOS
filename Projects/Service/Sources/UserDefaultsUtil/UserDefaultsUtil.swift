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
        case recentKeyword
        case feedTitle
        case feedContent
    }
    
    public func isLogin() -> Bool {
        let accessToke = KeychainStore.shared.read(label: "accessToken")
        return getInstallationId() != 0 && accessToke != nil
    }
    
    public func setRecentKeywordList(_ dataList: [String]) {
        defaults.setValue(dataList, forKey: UserDefaultKey.recentKeyword.rawValue)
    }
    
    public func recentKeywordList() -> [String]? {
        return defaults.value(forKey: UserDefaultKey.recentKeyword.rawValue) as? [String]
    }
    
    public func setFeedTitle(_ title: String) {
        return defaults.setValue(title, forKey: UserDefaultKey.feedTitle.rawValue)
    }
    
    public func getFeedTitle() -> String? {
        return defaults.value(forKey: UserDefaultKey.feedTitle.rawValue) as? String
    }
    
    public func setFeedContent(_ content: String) {
        return defaults.setValue(content, forKey: UserDefaultKey.feedContent.rawValue)
    }
    
    public func getFeedContent() -> String? {
        return defaults.value(forKey: UserDefaultKey.feedContent.rawValue) as? String
    }
    
    public func setUserId(_ id: Int) {
        defaults.setValue(id, forKey: UserDefaultKey.userId.rawValue)
    }
    
    public func getInstallationId() -> Int {
        return defaults.value(forKey: UserDefaultKey.userId.rawValue) as? Int ?? 0
    }
    
    public func remove(_ key: UserDefaultKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
