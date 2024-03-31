//
//  PopularFeed.swift
//  Feature
//
//  Created by 이범준 on 3/10/24.
//

import Foundation

struct PopularFeed {
    let title: String
    let feeds: [PopularDetailFeed]
    
    struct PopularDetailFeed {
        let feedId: Int
        let title: String
        let content: String
        let representImage: String
        let pairingIds: [Int]
        let images: [String]
        let likeCount: Int
        let userId: Int
        let userNickname: String
        let userImage: String
        let createdAt: String
        let updatedAt: String
    }
}
