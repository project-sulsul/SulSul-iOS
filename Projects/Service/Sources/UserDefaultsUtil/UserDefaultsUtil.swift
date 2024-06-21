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
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    public enum UserDefaultKey: String {
        case userId
        case recentKeyword
        case feedTitle
        case feedContent
        case blockUser
    }
    
    public func isLogin() -> Bool {
        let accessToken = KeychainStore.shared.read(label: "accessToken")
        return getInstallationId() != 0 && accessToken != nil
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
    
    public static func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
}

// MARK: - Generics for Feature module
//
extension UserDefaultsUtil {
    public func setObject<T: Codable>(_ object: T, forkey key: UserDefaultKey) {
        var objects = getObjects(T.self, forKey: key) ?? []
        objects.append(object)
        
        if let data = try? self.jsonEncoder.encode(objects) {
            defaults.setValue(data, forKey: UserDefaultKey.blockUser.rawValue)
        }
    }
    
    public func getObjects<T: Codable>(_ type: T.Type, forKey key: UserDefaultKey) -> [T]? {
        if let data = defaults.data(forKey: key.rawValue),
           let objects = try? self.jsonDecoder.decode([T].self, from: data) {
            return objects
        }
        
        return nil
    }
    
    public func removeObject<T: Codable & Equatable>(_ object: T, forKey key: UserDefaultKey) {
        var objects = getObjects(T.self, forKey: key) ?? []
        
        if let index = objects.firstIndex(of: object) {
            objects.remove(at: index)
            if let data = try? jsonEncoder.encode(objects) {
                defaults.setValue(data, forKey: key.rawValue)
            }
        }
    }
}
