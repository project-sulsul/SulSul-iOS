//
//  ReportResponseModel.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import Foundation

struct ReportResponseModel: Decodable {
    let id: Int?
    let reporterId: Int?
    let type: String?
    let targetId: Int?
    let reason: String?
}
