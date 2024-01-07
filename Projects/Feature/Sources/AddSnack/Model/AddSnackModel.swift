//
//  AddSnackModel.swift
//  Feature
//
//  Created by 김유진 on 2024/01/03.
//

import Foundation

struct SnackSortModel {
    let name: String
    var isSelect: Bool
}

struct AddSnackRequestModel {
    let type: String
    let subtype: String
    let name: String
}

struct UserModel: Codable {
    let id: Int
    let uid: String
    let nickname: String
    let image: String
    let preference: Preference
    let status: String
}

// MARK: - Preference
struct Preference: Codable {
    let additionalProp1, additionalProp2, additionalProp3: [String]
}
