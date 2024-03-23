//
//  MainPageMapper.swift
//  Feature
//
//  Created by 이범준 on 3/10/24.
//

import Foundation

struct MainPageMapper {
    func popularFeeds(from remotePopularFeeds: [RemotePopularFeedsItem]) -> [PopularFeed] {
        return remotePopularFeeds.map { feed -> PopularFeed in
            let detailFeeds = feed.feeds ?? []
            return PopularFeed(
                title: feed.title ?? "",
                feeds: detailFeeds.map { detailFeed in
                    return PopularFeed.PopularDetailFeed(
                        feedId: detailFeed.feedId ?? 0,
                        title: detailFeed.title ?? "",
                        content: detailFeed.content ?? "",
                        representImage: detailFeed.representImage ?? "",
                        pairingIds: detailFeed.pairingIds ?? [],
                        images: detailFeed.images ?? [],
                        likeCount: detailFeed.likeCount ?? 0,
                        userId: detailFeed.userId ?? 0,
                        userNickname: detailFeed.userNickname ?? "",
                        userImage: detailFeed.userImage ?? "",
                        createdAt: detailFeed.createdAt ?? "",
                        updatedAt: detailFeed.updatedAt ?? ""
                    )
                }
            )
        }
    }
    
    func kindOfAlcohol(from alcohols: [String]) -> [CanSelectAlcoholModel] {
        return alcohols.map { alcohol -> CanSelectAlcoholModel in
            return CanSelectAlcoholModel(title: alcohol)
        }
    }
}
