//
//  UserInfoModel.swift
//  Feature
//
//  Created by 이범준 on 2024/01/23.
//

import Foundation

struct UserInfoModel: Decodable {
    let id: Int?
    let uid: String?
    let nickname: String?
    let image: String?
    let preference: Preference?
    let status: String?
    
    struct Preference: Decodable {
        let foods: [Int]?
        let alcohols: [Int]?
    }
}
