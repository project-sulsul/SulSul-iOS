//
//  WriteContentViewModel.swift
//  Feature
//
//  Created by 김유진 on 2/19/24.
//

import Service
import UIKit
import Combine
import Alamofire

enum LogicType {
    case getAIData
    case createFeed
}

final class WriteContentViewModel {
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var currentLogicType: LogicType = .getAIData
    private lazy var imageCount = 0
    lazy var imageServerURLOfThumnail: String? = nil
    lazy var imageServerURLArrOfFeed = [String]()
    
    lazy var requestModel: WriteContentModel.WriteFeedRequestModel? = nil
    
    // MARK: trigger
    private lazy var completeUpload = PassthroughSubject<Void, Never>()
    private lazy var recognizeImageToAI = PassthroughSubject<Void, Never>()
    lazy var shouldUploadFeed = PassthroughSubject<[UIImage], Never>()
    
    // MARK: output
    lazy var completeRecognizeAI = PassthroughSubject<WriteContentModel.Recognized, Never>()
    lazy var completeCreateFeed = PassthroughSubject<Bool, Never>()
    private lazy var error = CurrentValueSubject<Void, Never>(())
    
    init() {
        completeUpload
            .sink { [weak self] in
                self?.recognizeImageToAI.send(())
            }
            .store(in: &cancelBag)
        
        recognizeImageToAI
            .sink { [weak self] in
                self?.currentLogicType = .getAIData
                self?.requestRecognizeImage()
            }
            .store(in: &cancelBag)
        
        shouldUploadFeed
            .sink { [weak self] images in
                self?.imageServerURLArrOfFeed = []
                self?.imageCount = images.count
                self?.currentLogicType = .createFeed
                
                images.forEach { image in
                    self?.uploadImage(image)
                }
            }
            .store(in: &cancelBag)
    }
    
    func errorPublisher() -> AnyPublisher<Void, Never> {
        return error.dropFirst().eraseToAnyPublisher()
    }
    
    func uploadImage(_ image: UIImage) {
        NetworkWrapper.shared.postUploadImage(stringURL: "/files/upload?directory=images", image: image) { [weak self] result in
            guard let selfRef = self else { return }
            
            switch result {
            case .success(let response):
                if let decodedData = try? selfRef.jsonDecoder.decode(WriteContentModel.self, from: response) {
                    if selfRef.currentLogicType == .createFeed {
                        selfRef.imageServerURLArrOfFeed.append(decodedData.url)
                        if selfRef.imageServerURLArrOfFeed.count == selfRef.imageCount,
                           let requestModel = selfRef.requestModel {
                            
                            selfRef.imageServerURLArrOfFeed.removeFirst()
                            selfRef.uploadFeed(requestModel)
                        }
                        
                    } else if selfRef.currentLogicType == .getAIData {
                        selfRef.imageServerURLOfThumnail = decodedData.url
                        selfRef.completeUpload.send(())
                    }
                } else {
                    if selfRef.currentLogicType == .createFeed {
                        selfRef.error.send(())
                        
                    } else {
                        selfRef.completeRecognizeAI.send(.init(foods: [], alcohols: []))
                    }
                    print("[/users/id] Fail Decode")
                }
            case .failure(let error):
                if selfRef.currentLogicType == .createFeed {
                    selfRef.error.send(())
                    
                } else {
                    selfRef.error.send(())
                    selfRef.completeRecognizeAI.send(.init(foods: [], alcohols: []))
                }
                print("[/files/upload] Fail : \(error)")
            }
        }
    }
    
    private func uploadFeed(_ requestModel: WriteContentModel.WriteFeedRequestModel) {
        guard let url = imageServerURLOfThumnail else {
            completeCreateFeed.send(false)
            return
        }
        
        let parameters: Parameters = [
            "title": requestModel.title,
            "content": requestModel.content,
            "represent_image": url,
            "images": imageServerURLArrOfFeed,
            "alcohol_pairing_ids": requestModel.alcohol_pairing_ids,
            "food_pairing_ids": requestModel.food_pairing_ids,
            "user_tags_raw_string": requestModel.user_tags_raw_string,
            "score": requestModel.score
        ]
        
        NetworkWrapper.shared.postBasicTask(stringURL: "/feeds", parameters: parameters, needToken: true) { [weak self] result in
            guard let selfRef = self else { return }

            switch result {
            case .success(_):
                UserDefaultsUtil.shared.remove(.feedTitle)
                UserDefaultsUtil.shared.remove(.feedContent)
                selfRef.completeCreateFeed.send(true)
                
            case .failure(let error):
                selfRef.completeCreateFeed.send(false)
                print("[/feeds] Fail : \(error)")
            }
        }
    }
    
    private func requestRecognizeImage() {
        guard let url = imageServerURLOfThumnail else { return }
        
        NetworkWrapper.shared.postBasicTask(stringURL: "/feeds/classifications?image_url=\(url)") { [weak self] result in
            guard let selfRef = self else { return }

            switch result {
            case .success(let response):
                if let decodedData = try? selfRef.jsonDecoder.decode(WriteContentModel.Recognized.self, from: response) {
                    
                    selfRef.completeRecognizeAI.send(decodedData)
                } else {
                    selfRef.completeRecognizeAI.send(.init(foods: [], alcohols: []))
                    print("[/feeds/classifications] Fail Decode")
                }
            case .failure(let error):
                selfRef.completeRecognizeAI.send(.init(foods: [], alcohols: []))
                print("[/feeds/classifications] Fail : \(error)")
            }
        }
    }
}
