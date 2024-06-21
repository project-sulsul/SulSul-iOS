//
//  AlcoholFeed.swift
//  Feature
//
//  Created by 이범준 on 2024/03/22.
//

import Foundation

struct AlcoholFeed {
    let subtypes: [String]
    let feeds: [Feed]
    
    struct Feed {
        let subtype: String
        let feedId: Int
        let title: String
        let representImage: URL
        let foods: [String]
        let score: Int
        let writerNickname: String
    }
}
