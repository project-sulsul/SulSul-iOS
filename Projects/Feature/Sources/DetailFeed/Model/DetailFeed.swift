//
//  DetailFeed.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import Foundation

struct DetailFeed {
    struct Feed: Decodable {
        let feedID: Int
        let writerInfo: DetailFeed.WriterInfo?
        let title: String
        let content: String
        let images: [String]
        let alcoholPairingIDs: [Int]
        let snackPairingIDs: [Int]
//        let userTags: [String]?
        let isLiked: Bool
        let viewCount: Int
        let likeCount: Int
        let commentCount: Int
        let score: Int
        let createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case feedID = "feed_id"
            case writerInfo = "writer_info"
            case title
            case content
            case images
            case alcoholPairingIDs = "alcohol_pairing_ids"
            case snackPairingIDs = "food_pairing_ids"
//            case userTags = "user_tags"
            case isLiked = "is_liked"
            case viewCount = "view_count"
            case likeCount = "likes_count"
            case commentCount = "comments_count"
            case score
            case createdAt = "created_at"
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<DetailFeed.Feed.CodingKeys> = try decoder.container(keyedBy: DetailFeed.Feed.CodingKeys.self)
            self.feedID = try container.decode(Int.self, forKey: DetailFeed.Feed.CodingKeys.feedID)
            self.writerInfo = try? container.decode(DetailFeed.WriterInfo.self, forKey: DetailFeed.Feed.CodingKeys.writerInfo)
            self.title = try container.decode(String.self, forKey: DetailFeed.Feed.CodingKeys.title)
            self.content = try container.decode(String.self, forKey: DetailFeed.Feed.CodingKeys.content)
            self.images = try container.decode([String].self, forKey: DetailFeed.Feed.CodingKeys.images)
            self.alcoholPairingIDs = try container.decode([Int].self, forKey: DetailFeed.Feed.CodingKeys.alcoholPairingIDs)
            self.snackPairingIDs = try container.decode([Int].self, forKey: DetailFeed.Feed.CodingKeys.snackPairingIDs)
//            self.userTags = try container.decode([String].self, forKey: DetailFeed.Feed.CodingKeys.userTags)
            self.isLiked = try container.decode(Bool.self, forKey: DetailFeed.Feed.CodingKeys.isLiked)
            self.viewCount = try container.decode(Int.self, forKey: DetailFeed.Feed.CodingKeys.viewCount)
            self.likeCount = try container.decode(Int.self, forKey: DetailFeed.Feed.CodingKeys.likeCount)
            self.commentCount = try container.decode(Int.self, forKey: DetailFeed.Feed.CodingKeys.commentCount)
            self.score = try container.decode(Int.self, forKey: DetailFeed.Feed.CodingKeys.score)
            self.createdAt = try container.decode(String.self, forKey: DetailFeed.Feed.CodingKeys.createdAt)
        }
    }
    
    struct WriterInfo: Decodable {
        let userID: Int
        let nickname: String
        let image: String?
        
        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case nickname
            case image
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<DetailFeed.WriterInfo.CodingKeys> = try decoder.container(keyedBy: DetailFeed.WriterInfo.CodingKeys.self)
            self.userID = try container.decode(Int.self, forKey: DetailFeed.WriterInfo.CodingKeys.userID)
            self.nickname = try container.decode(String.self, forKey: DetailFeed.WriterInfo.CodingKeys.nickname)
            self.image = try? container.decode(String.self, forKey: DetailFeed.WriterInfo.CodingKeys.image)
        }
    }
    
    struct PairingStack: Decodable {
        let alcohol: Pairings
        let snack: Pairings
    }
}
