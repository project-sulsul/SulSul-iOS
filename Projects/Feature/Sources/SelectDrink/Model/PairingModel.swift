//
//  PairingModel.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import Foundation

struct PairingModel: Decodable {
    var pairings: [Pairing]?
}
struct Pairing: Decodable {
    var id: Int?
    var type: String?
    var name: String?
    var image: String?
    var description: String?
}