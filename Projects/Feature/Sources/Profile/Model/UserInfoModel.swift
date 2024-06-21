//
//  UserInfoModel.swift
//  Feature
//
//  Created by 이범준 on 2024/01/23.
//

import Foundation

struct UserInfoModel {
    let id: Int
    let uid: String
    let nickname: String
    let image: String
    let preference: Preference
    let status: String
    
    struct Preference {
        let alcohols: [Int]
        let foods: [Int]
    }
}
