//
//  DeleteFeedResponse.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-08.
//

import Foundation

struct DeleteFeedResponse: Decodable {
    let feedID: Int
    let isDeleted: Bool
    let deletedCommentsCount: Int
    let deletedLikesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case feedID = "feed_id"
        case isDeleted = "is_deleted"
        case deletedCommentsCount = "deleted_comments_count"
        case deletedLikesCount = "deleted_likes_count"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.feedID = try container.decode(Int.self, forKey: .feedID)
        self.isDeleted = try container.decode(Bool.self, forKey: .isDeleted)
        self.deletedCommentsCount = try container.decode(Int.self, forKey: .deletedCommentsCount)
        self.deletedLikesCount = try container.decode(Int.self, forKey: .deletedLikesCount)
    }
}
