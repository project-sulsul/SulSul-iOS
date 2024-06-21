//
//  DetailCommentViewModel.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-19.
//

import Foundation
import Combine
import Service

final class DetailCommentViewModel {
    var feedID: Int
    // 답글을 전부 제외한 댓글 datasource
    var commentsWithoutChildrens: [Comment] = []
    var reloadData = CurrentValueSubject<Void, Never>(())
    
    private let jsonDecoder = JSONDecoder()
    private let networkWrapper = NetworkWrapper.shared
    
    private var cancelBag = Set<AnyCancellable>()
    private var errorSubject = CurrentValueSubject<NetworkError, Never>(NetworkError(message: ""))
    
    init(feedID: Int) {
        self.feedID = feedID
        
        self.getCommentsWithoutChildrens(feedID)
            .sink { [weak self] value in
                self?.commentsWithoutChildrens = value
                self?.reloadData.send(())
            }
            .store(in: &cancelBag)
    }
}

// MARK: - API Request
//
extension DetailCommentViewModel {
    private func getCommentsWithoutChildrens(_ feedID: Int) -> AnyPublisher<[Comment], Never> {
        return Future<[Comment], Never> { promise in
            NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedID)/comments") { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    let decoder = JSONDecoder()
                    
                    if let data = try? decoder.decode(CommentModel.self, from: success) {
                        
                        let dataWithoutChildren = data.comments.map { cData -> Comment in
                            var comment = cData
                            comment.children_comments = []
                            
                            return comment
                        }
                        
                        return promise(.success(dataWithoutChildren.reversed()))
                    } else {
                        debugPrint("\(#function) -- Failed decoding")
                        return selfRef.errorSubject.send(.init(message: "\(#function) -- Failed decoding"))
                    }
                case .failure(let failure):
                    debugPrint("\(#function) -- API Request failed, reason is \(failure)")
                    return selfRef.errorSubject.send(.init(message: "\(#function) -- API Request failed, reason is \(failure)"))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
