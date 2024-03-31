//
//  SnackModelMapper.swift
//  Feature
//
//  Created by 김유진 on 2023/12/18.
//

import Foundation

struct PairingModelMapper {
    func pairingModel(from pairingModels: [Pairing]) -> [Pairing] {
        return pairingModels.map { pairingModel -> Pairing in
            return Pairing(id: pairingModel.id ?? 0,
                              type: pairingModel.type ?? "",
                              subtype: pairingModel.subtype ?? "",
                              name: pairingModel.name ?? "",
                              image: pairingModel.image ?? "",
                              description: pairingModel.description ?? "",
                              isSelect: pairingModel.isSelect ?? false,
                              highlightedText: pairingModel.highlightedText ?? "")
        }
    }
}
