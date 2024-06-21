//
//  Ranking.swift
//  Feature
//
//  Created by Yujin Kim on 2024-01-07.
//

import Foundation

struct Ranking: Codable {
    let startDate: String?
    let endDate: String?
    let ranking: [RankingItem]?
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
        case ranking
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.ranking = try container.decodeIfPresent([RankingItem].self, forKey: .ranking)
    }
}
