//
//  FeedDetail.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import Foundation

struct FeedDetail: Decodable {
    let feedID: Int
    let writerInfo: FeedDetail.WriterInfo?
    let title: String
    let content: String
    let representImage: String
    let images: [String]
    let alcoholPairingIDs: [Int]
    let snackPairingIDs: [Int]
    let userTags: [String]?
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
        case representImage = "represent_image"
        case images
        case alcoholPairingIDs = "alcohol_pairing_ids"
        case snackPairingIDs = "food_pairing_ids"
        case userTags = "user_tags"
        case isLiked = "is_liked"
        case viewCount = "view_count"
        case likeCount = "likes_count"
        case commentCount = "comments_count"
        case score
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<FeedDetail.CodingKeys> = try decoder.container(keyedBy: FeedDetail.CodingKeys.self)
        
        self.feedID = try container.decode(Int.self, forKey: FeedDetail.CodingKeys.feedID)
        self.writerInfo = try? container.decode(FeedDetail.WriterInfo.self, forKey: FeedDetail.CodingKeys.writerInfo)
        self.title = try container.decode(String.self, forKey: FeedDetail.CodingKeys.title)
        self.content = try container.decode(String.self, forKey: FeedDetail.CodingKeys.content)
        self.representImage = try container.decode(String.self, forKey: FeedDetail.CodingKeys.representImage)
        self.images = try container.decode([String].self, forKey: FeedDetail.CodingKeys.images)
        self.alcoholPairingIDs = try container.decode([Int].self, forKey: FeedDetail.CodingKeys.alcoholPairingIDs)
        self.snackPairingIDs = try container.decode([Int].self, forKey: FeedDetail.CodingKeys.snackPairingIDs)
        self.userTags = try? container.decode([String].self, forKey: FeedDetail.CodingKeys.userTags)
        self.isLiked = try container.decode(Bool.self, forKey: FeedDetail.CodingKeys.isLiked)
        self.viewCount = try container.decode(Int.self, forKey: FeedDetail.CodingKeys.viewCount)
        self.likeCount = try container.decode(Int.self, forKey: FeedDetail.CodingKeys.likeCount)
        self.commentCount = try container.decode(Int.self, forKey: FeedDetail.CodingKeys.commentCount)
        self.score = try container.decode(Int.self, forKey: FeedDetail.CodingKeys.score)
        self.createdAt = try container.decode(String.self, forKey: FeedDetail.CodingKeys.createdAt)
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
            let container: KeyedDecodingContainer<FeedDetail.WriterInfo.CodingKeys> = try decoder.container(keyedBy: FeedDetail.WriterInfo.CodingKeys.self)
            
            self.userID = try container.decode(Int.self, forKey: FeedDetail.WriterInfo.CodingKeys.userID)
            self.nickname = try container.decode(String.self, forKey: FeedDetail.WriterInfo.CodingKeys.nickname)
            self.image = try? container.decode(String.self, forKey: FeedDetail.WriterInfo.CodingKeys.image)
        }
    }
    
    struct FeedLike: Encodable {
        let feedID: Int
        let isLiked: Bool
    }
}
