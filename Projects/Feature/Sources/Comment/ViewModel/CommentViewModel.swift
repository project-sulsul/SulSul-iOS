//
//  CommentViewModel.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import Foundation
import Combine
import Service
import Alamofire

final class CommentViewModel {
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: Datasource
    var comments: [Comment] = []
    
    // MARK: Trigger
    private lazy var writeComment = CurrentValueSubject<WriteCommentRequest, Never>(.init(feed_id: 0, content: "", parent_comment_id: 0))
    private lazy var deleteComment = CurrentValueSubject<DeleteCommentRequest, Never>(.init(feed_id: 0, comment_id: 0))
    
    // MARK: Output
    lazy var reloadData = CurrentValueSubject<Void, Never>(())
    private lazy var errorSubject = CurrentValueSubject<NetworkError, Never>(NetworkError(message: "Init"))
    
    init(feedId: Int) {
        getComments(feedId)
            .sink { [weak self] comments in
                self?.comments = comments
                self?.reloadData.send(())
            }
            .store(in: &cancelBag)
        
        writeComment
            .dropFirst()
            .flatMap(postComments(_:))
            .sink { [weak self] comment in
                guard let selfRef = self else { return }
                
                let parentId = selfRef.writeComment.value.parent_comment_id
                
                if parentId == 0 {
                    // MARK: 기본 댓글 추가
                    self?.comments.append(comment)
                    
                } else {
                    // MARK: 대댓글 추가
                    var commentWithParentId = comment
                    commentWithParentId.parent_comment_id = parentId
                    commentWithParentId.isChildren = true
                    
                    if let parentIndex = self?.comments.firstIndex(where: { $0.comment_id == parentId }),
                       let originChildrenCount = selfRef.comments[parentIndex].children_comments?.count {
                        self?.comments.insert(commentWithParentId, at: parentIndex + originChildrenCount + 1)
                        self?.comments[parentIndex].children_comments?.append(commentWithParentId)
                    }
                }
                self?.reloadData.send(())
            }
            .store(in: &cancelBag)
        
        deleteComment
            .dropFirst()
            .flatMap(deleteComment(_:))
            .sink { [weak self] in
                guard let selfRef = self else { return }
                
                let commentId = selfRef.deleteComment.value.comment_id
                
                // MARK: 기본 댓글 제거
                self?.comments.removeAll(where: { $0.comment_id == commentId })
                
                self?.comments.enumerated().forEach({ index, data in
                    // MARK: 대댓글까지 제거
                    self?.comments[index].children_comments?.removeAll(where: { $0.comment_id == commentId })
                })
                
                self?.reloadData.send(())
            }
            .store(in: &cancelBag)
    }
    
    func didTabDeleteComment(_ request: DeleteCommentRequest) {
        deleteComment.send(request)
    }
    
    func didTabWriteComment(_ feedId: Int, content: String, parentId: Int) {
        writeComment.send(.init(feed_id: feedId,
                                content: content,
                                parent_comment_id: parentId))
    }
    
    func errorPublisher() -> AnyPublisher<NetworkError, Never> {
        return errorSubject.dropFirst().eraseToAnyPublisher()
    }
}

// MARK: API Request Functions
extension CommentViewModel {
    private func deleteComment(_ request: DeleteCommentRequest) -> AnyPublisher<Void, Never> {
        return Future<Void, Never> { promise in
            NetworkWrapper.shared.deleteBasicTask(stringURL: "/feeds/\(request.feed_id)/comments/\(request.comment_id)", needToken: true) { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    return promise(.success(()))
                case .failure(let failure):
                    print("[delete: /feeds/id/comments/commentId] fail API : \(failure)")
                    selfRef.errorSubject.send(.init(message: "[delete: /feeds/id/comments/commentId] fail API"))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func postComments(_ request: WriteCommentRequest) -> AnyPublisher<Comment, Never> {
        return Future<Comment, Never> { promise in
            
            let parameters: Parameters = [
                "content": request.content,
                "parent_comment_id": request.parent_comment_id
            ]
            
            NetworkWrapper.shared.postBasicTask(stringURL: "/feeds/\(request.feed_id)/comments", parameters: parameters, needToken: true) { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    let decoder = JSONDecoder()
                    
                    if let data = try? decoder.decode(Comment.self, from: success) {
                        return promise(.success(data))
                    } else {
                        print("[/feeds/id/comments] fail Decoding")
                        selfRef.errorSubject.send(.init(message: "[/feeds/id/comments] fail Decoding"))
                    }
                case .failure(let failure):
                    print("[/feeds/id/comments] fail API : \(failure)")
                    selfRef.errorSubject.send(.init(message: "[/feeds/id/comments] fail API"))
                }
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    private func getComments(_ feedId: Int) -> AnyPublisher<[Comment], Never> {
        return Future<[Comment], Never> { promise in
            NetworkWrapper.shared.getBasicTask(stringURL: "/feeds/\(feedId)/comments") { [weak self] result in
                guard let selfRef = self else { return }
                
                switch result {
                case .success(let success):
                    let decoder = JSONDecoder()
                    
                    if let data = try? decoder.decode(CommentModel.self, from: success) {
                        
                        // MARK: Children을 기본 Comment와 동일한 depth에 위치하도록 세팅하는 코드 (flatMap 처리)
                        var dataWithChildren = data.comments
                
                        dataWithChildren.enumerated().forEach { index, data in
                            data.children_comments?.enumerated().forEach { cIndex, cData in
                                var childrenComment = cData
                                childrenComment.isChildren = true
                                dataWithChildren.insert(childrenComment, at: index + 1 + cIndex)
                            }
                        }
                        
                        return promise(.success(dataWithChildren))
                    } else {
                        print("[/comments] fail Decoding")
                        return selfRef.errorSubject.send(.init(message: "[/comments] fail Decoding"))
                    }
                case .failure(let failure):
                    print("[/comments] fail API : \(failure)")
                    return selfRef.errorSubject.send(.init(message: "[/comments] fail API"))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
