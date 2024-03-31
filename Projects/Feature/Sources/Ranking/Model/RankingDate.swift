//
//  RankingDate.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import Foundation

struct RankingDate: Decodable {
    let startDate: String
    let endDate: String
    
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startDate = try container.decode(String.self, forKey: .startDate)
        self.endDate = try container.decode(String.self, forKey: .endDate)
    }
}
