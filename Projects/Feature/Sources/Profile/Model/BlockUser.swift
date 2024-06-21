//
//  BlockUser.swift
//  Feature
//
//  Created by Yujin Kim on 2024-06-01.
//

import Foundation

struct BlockUser: Codable, Equatable {
    let id: Int
    let name: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nickname"
        case image
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}
