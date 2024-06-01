//
//  Block.swift
//  Feature
//
//  Created by Yujin Kim on 2024-06-01.
//

import Foundation

struct Block: Decodable {
    let targetUserID: Int
    
    enum CodingKeys: String, CodingKey {
        case targetUserID = "target_user_id"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.targetUserID = try container.decode(Int.self, forKey: .targetUserID)
    }
}
