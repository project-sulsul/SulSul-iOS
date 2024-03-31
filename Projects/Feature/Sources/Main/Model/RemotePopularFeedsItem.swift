//
//  RemotePopularFeedsItem.swift
//  Feature
//
//  Created by 이범준 on 3/10/24.
//

import Foundation

struct RemotePopularFeedsItem: Decodable {
    let title: String?
    let feeds: [RemotePopularDetailFeed]?
}

struct RemotePopularDetailFeed: Decodable {
    let feedId: Int?
    let title: String?
    let content: String?
    let representImage: String?
    let pairingIds: [Int]?
    let images: [String]?
    let likeCount: Int?
    let userId: Int?
    let userNickname: String?
    let userImage: String?
    let createdAt: String?
    let updatedAt: String?
    
    private enum CodingKeys: String, CodingKey {
        case feedId = "feed_id"
        case title
        case content
        case representImage = "represent_image"
        case pairingIds = "pairing_ids"
        case images
        case likeCount = "like_count"
        case userId = "user_id"
        case userNickname = "user_nickname"
        case userImage = "user_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
