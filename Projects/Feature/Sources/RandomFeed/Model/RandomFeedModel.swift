//
//  RandomFeedModel.swift
//  Feature
//
//  Created by 김유진 on 3/8/24.
//

import Foundation

struct RandomFeedModel {
    struct Feeds: Decodable {
        let ids_list: [Int]
        let ids_string: String
        let feeds: [Feed]
    }
    
    struct Feed: Decodable {
        let feed_id: Int
        let title: String
        let content: String
        let represent_image: String
        let user_id: Int
        let user_nickname: String
        let user_image: String?
        var likes_count: Int
        let updated_at: String
        let comments_count: Int
        var is_liked: Bool
    }
    
    struct Request {
        let exclude_feed_ids: String
    }
    
    struct Heart: Decodable {
        let feed_id: Int
        let is_liked: Bool
    }
}
