//
//  WriteContentModel.swift
//  Feature
//
//  Created by 김유진 on 3/5/24.
//

import Foundation

struct WriteContentModel: Decodable {
    let url: String
    
    struct Recognized: Decodable {
        let foods: [String]
        let alcohols: [String]
    }
    
    struct WriteFeedRequestModel {
        let title: String
        let content: String
        let represent_image: String
        let images: [String]
        let alcohol_pairing_ids: [Int]?
        let food_pairing_ids: [Int]?
        let user_tags_raw_string: String
        let score: Int
    }
}
