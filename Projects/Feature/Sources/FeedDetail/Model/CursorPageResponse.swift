//
//  CursorPageResponse.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-20.
//

import Foundation

struct CursorPageResponse: Decodable {
    let nextCursorID: Int
    let size: Int
    let isLast: Bool
    let content: [RelatedFeed]
    
    enum CodingKeys: String, CodingKey {
        case nextCursorID = "next_cursor_id"
        case size
        case isLast = "is_last"
        case content
    }
}
