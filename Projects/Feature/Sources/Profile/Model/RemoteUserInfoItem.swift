//
//  RemoteUserInfoItem.swift
//  Feature
//
//  Created by 이범준 on 1/21/24.
//

import Foundation

struct RemoteUserInfoItem: Decodable {
    let id: Int?
    let uid: String?
    let nickname: String?
    let image: String?
    let preference: Preference?
    let status: String?
    
    struct Preference: Decodable {
        let foods: [Int]
        let alcohols: [Int]
    }
}
