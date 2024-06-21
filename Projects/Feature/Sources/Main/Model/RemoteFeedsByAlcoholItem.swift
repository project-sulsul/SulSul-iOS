//
//  RemoteFeedsByAlcoholItem.swift
//  Feature
//
//  Created by 이범준 on 3/20/24.
//

import Foundation

struct RemoteFeedsByAlcoholItem: Decodable {
    let subtypes: [String]?
    let feeds: [Feed]?
    
    struct Feed: Decodable {
        let subtype: String?
        let feedId: Int?
        let title: String?
        let representImage: URL?
        let foods: [String]?
        let score: Int?
        let writerNickname: String?
        
        enum CodingKeys: String, CodingKey {
            case subtype
            case feedId = "feed_id"
            case title
            case representImage = "represent_image"
            case foods
            case score
            case writerNickname = "writer_nickname"
        }
    }
}
