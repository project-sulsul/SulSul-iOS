//
//  SearchModel.swift
//  Feature
//
//  Created by 김유진 on 3/22/24.
//

import Foundation

struct SearchModel: Decodable {
    let results: [SearchResult]
}

// Result.swift

import Foundation

// MARK: - Result
struct SearchResult: Decodable {
    let feed_id: Int
    let title: String
    let represent_image: String
    let content: String
    let tags: [String]
}
