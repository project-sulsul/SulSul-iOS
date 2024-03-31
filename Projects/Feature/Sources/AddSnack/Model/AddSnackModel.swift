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
