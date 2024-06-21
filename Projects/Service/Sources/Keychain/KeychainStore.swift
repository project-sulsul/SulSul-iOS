//
//  KeychainStore.swift
//  Service
//
//  Created by Yujin Kim on 2023-12-12.
//

import Foundation
import Security

public final class KeychainStore {
    public static let shared = KeychainStore()
    
    let service = "com.SulSul-iOS"
    
    public func read(label: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrLabel as String: label,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: true,
            kSecReturnAttributes as String: true
        ]
        
        var reference: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &reference)
        guard status != errSecItemNotFound else {
            print("키체인에서 해당하는 값을 찾지 못했습니다. KeychainManagerStatus: \(status)")
            return nil
        }
        guard status == errSecSuccess else {
            print("키체인에서 값을 불러오는 데 실패했습니다. KeychainManagerStatus: \(status)")
            return nil
        }
        guard let item = reference as? [String: Any],
              let data = item[kSecValueData as String] as? Data,
              let token = String(data: data, encoding: .utf8)
        else {
            print("키체인에서 값을 가져오는 데 실패했습니다. KeychainManagerStatus: \(status)")
            return nil
        }
        return token
    }
    
    @discardableResult
    public func create(item: String, label: String) -> Bool {
        if read(label: label) != nil {
            if update(item: item, label: label) {
                return true
            } else if delete(label: label) {
                return create(item: item, label: label)
            } else {
                return false
            }
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrLabel as String: label,
            kSecValueData as String: item.data(using: .utf8) as Any,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("키체인에 토큰 정보를 생성하는데 실패했습니다. KeychainStoreStatus: \(status)")
            return false
        }
        
        print("키체인에 값이 성공적으로 저장되었습니다. label: \(label), value: \(item)")
        return true
    }
    
    @discardableResult
    public func delete(label: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrLabel as String: label,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            print("키체인에서 값을 제거하지 못했습니다. KeychainStoreStatus: \(status)")
            return false
        }
        return true
    }
    
    @discardableResult
    public func update(item: String, label: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrLabel as String: label,
            kSecValueData as String: item.data(using: .utf8) as Any
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status != errSecItemNotFound else {
            print("키체인에서 해당하는 값을 찾지 못했습니다. KeychainStoreStatus: \(status)")
            return false
        }
        guard status == errSecSuccess else {
            print("키체인에서 값을 삭제하지 못했습니다. KeychainStoreStatus: \(status)")
            return false
        }
        return true
    }
}
