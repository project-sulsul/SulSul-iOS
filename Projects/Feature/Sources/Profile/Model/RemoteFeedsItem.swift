//
//  RemoteFeedsByMeItem.swift
//  Feature
//
//  Created by 이범준 on 1/20/24.
//

import Foundation

struct RemoteFeedsItem: Decodable {
    let nextCursorId: Int?
    let size: Int?
    let isLast: Bool?
    let content: [RemoteFeed]?

    private enum CodingKeys: String, CodingKey {
        case nextCursorId = "next_cursor_id"
        case size
        case isLast = "is_last"
        case content
    }
}

struct RemoteFeed: Decodable {
    let feedId: Int?
    let writerInfo: RemoteWriterInfo?
    let title: String?
    let content: String?
    let representImage: String?
    let images: [String]?
    let alcoholPairingIds: [Int]?
    let foodPairingIds: [Int]?
    let isLiked: Bool?
    let viewCount: Int?
    let likesCount: Int?
    let commentsCount: Int?
    let score: Int?
    let createdAt: String?
    let updatedAt: String?

    private enum CodingKeys: String, CodingKey {
        case feedId = "feed_id"
        case writerInfo = "writer_info"
        case title
        case content
        case representImage = "represent_image"
        case images
        case alcoholPairingIds = "alcohol_pairing_ids"
        case foodPairingIds = "food_pairing_ids"
        case isLiked = "is_liked"
        case viewCount = "view_count"
        case likesCount = "likes_count"
        case commentsCount = "comments_count"
        case score
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct RemoteWriterInfo: Decodable {
    let userId: Int?
    let nickname: String?
    let image: String?

    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickname
        case image
    }
}
