//
//  RankingItem.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-07.
//

import Foundation

struct RankingItem: Codable {
    let rank: Int?
    let drink: Drink?
    let pairings: [Pairings]?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case rank = "rank"
        case drink = "alcohol"
        case pairings
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rank = try container.decodeIfPresent(Int.self, forKey: .rank)
        self.drink = try container.decodeIfPresent(Drink.self, forKey: .drink)
        self.pairings = try container.decodeIfPresent([Pairings].self, forKey: .pairings)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}
