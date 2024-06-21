//
//  SnackModelMapper.swift
//  Feature
//
//  Created by 김유진 on 2023/12/18.
//

import Foundation

struct PairingModelMapper {
    func pairingModel(from pairingModels: [Pairing]) -> [SnackModel] {
        return pairingModels.map { pairingModel -> SnackModel in
            return SnackModel(id: pairingModel.id ?? 0,
                              type: pairingModel.type ?? "",
                              subtype: pairingModel.subtype ?? "",
                              name: pairingModel.name ?? "",
                              image: pairingModel.image ?? "",
                              description: pairingModel.description ?? "",
                              isSelect: pairingModel.isSelect ?? false,
                              highlightedText: pairingModel.highlightedText ?? "")
        }
    }
    
    func snackModel(from pairingModels: [Pairing]) -> [SnackModel] {
        return pairingModels.map { pairingModel -> SnackModel in
            return SnackModel(id: pairingModel.id ?? 0,
                              type: pairingModel.type ?? "",
                              subtype: pairingModel.subtype ?? "",
                              name: pairingModel.name ?? "",
                              image: pairingModel.image ?? "",
                              description: pairingModel.description ?? "",
                              isSelect: pairingModel.isSelect ?? false,
                              highlightedText: pairingModel.highlightedText ?? "")
        }
    }
    
    // TODO: - mapper 함수 파일 수정
    
    func feedModel(from feeds: [RemoteFeed]) -> [Feed] {
        return feeds.map { feed -> Feed in
            return Feed(feedId: feed.feedId ?? 0,
                        writerInfo: WriterInfo(userId: feed.writerInfo?.userId ?? 0,
                                               nickname: feed.writerInfo?.nickname ?? "",
                                               image: feed.writerInfo?.image ?? ""),
                        title: feed.title ?? "",
                        content: feed.content ?? "",
                        representImage: feed.representImage ?? "",
                        images: feed.images ?? [],
                        alcoholPairingIds: feed.alcoholPairingIds ?? [],
                        foodPairingIds: feed.foodPairingIds ?? [],
                        isLiked: feed.isLiked ?? false,
                        viewCount: feed.viewCount ?? 0,
                        likesCount: feed.likesCount ?? 0,
                        commentsCount: feed.commentsCount ?? 0,
                        score: feed.score ?? 0,
                        createdAt: feed.createdAt ?? "",
                        updatedAt: feed.updatedAt ?? "")
        }
    }
}
