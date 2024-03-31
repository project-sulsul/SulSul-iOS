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
}
