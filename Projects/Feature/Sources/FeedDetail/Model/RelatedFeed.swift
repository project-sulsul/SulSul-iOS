//
//  RelatedFeed.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-20.
//

import Foundation

struct RelatedFeed: Decodable {
    let feedID: Int
    let title: String
    let representImage: String
    let score: Int
    let userTags: [String]?
    let alcoholTags: [String]
    let foodTags: [String]
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case feedID = "feed_id"
        case title
        case representImage = "represent_image"
        case score
        case userTags = "user_tags"
        case alcoholTags = "alcohol_tags"
        case foodTags = "food_tags"
        case isLiked = "is_liked"
    }
}
