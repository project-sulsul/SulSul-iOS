//
//  RemoteFeedsByMeItem.swift
//  Feature
//
//  Created by 이범준 on 1/20/24.
//

import Foundation

struct RemoteFeedsItem: Codable {
    let nextCursorId: Int
    let size: Int
    let isLast: Bool
    let content: [Feed]
    
    private enum CodingKeys: String, CodingKey {
        case nextCursorId = "next_cursor_id"
        case size
        case isLast = "is_last"
        case content
    }
}

struct Feed: Codable {
    let feedId: Int
    let writerInfo: WriterInfo
    let title: String
    let content: String
    let representImage: String
    let images: [String]
    let alcoholPairingIds: [Int]
    let foodPairingIds: [Int]
    let userTags: [String]?
    let isLiked: Bool
    let viewCount: Int
    let likesCount: Int
    let commentsCount: Int
    let score: Int
    let createdAt: String
    let updatedAt: String
    
    private enum CodingKeys: String, CodingKey {
            case feedId = "feed_id"
            case writerInfo = "writer_info"
            case title
            case content
            case representImage = "represent_image"
            case images
            case alcoholPairingIds = "alcohol_pairing_ids"
            case foodPairingIds = "food_pairing_ids"
            case userTags = "user_tags"
            case isLiked = "is_liked"
            case viewCount = "view_count"
            case likesCount = "likes_count"
            case commentsCount = "comments_count"
            case score
            case createdAt = "created_at"
            case updatedAt = "updated_at"
        }
}

struct WriterInfo: Codable {
    let userId: Int
    let nickname: String
    let image: String?
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickname
        case image
    }
}
