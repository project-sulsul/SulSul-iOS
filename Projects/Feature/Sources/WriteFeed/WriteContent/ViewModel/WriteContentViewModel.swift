//
//  WriteContentViewModel.swift
//  Feature
//
//  Created by 김유진 on 2/19/24.
//

import Service
import UIKit
import Combine

final class WriteContentViewModel {
    private let jsonDecoder = JSONDecoder()
    private var cancelBag = Set<AnyCancellable>()

    private lazy var imageCount = 0
    private lazy var imageServerURL: String? = nil
    
    // MARK: trigger
    private lazy var completeUpload = PassthroughSubject<Void, Never>()
    private lazy var recognizeImageToAI = PassthroughSubject<Void, Never>()
    
    // MARK: output
    lazy var completeRecognizeAI = PassthroughSubject<WriteContentModel.Recognized, Never>()
    
    init() {
        completeUpload
            .sink { [weak self] in
                self?.recognizeImageToAI.send(())
            }
            .store(in: &cancelBag)
        
        recognizeImageToAI
            .sink { [weak self] in
                self?.requestRecognizeImage()
            }
            .store(in: &cancelBag)
    }
    
    func uploadImage(_ image: UIImage) {
        NetworkWrapper.shared.postUploadImage(stringURL: "/files/upload?directory=images", image: image) { [weak self] result in
            guard let selfRef = self else { return }
            
            switch result {
            case .success(let response):
                if let decodedData = try? selfRef.jsonDecoder.decode(WriteContentModel.self, from: response) {
                    selfRef.imageServerURL = decodedData.url
                    selfRef.completeUpload.send(())
                } else {
                    print("[/users/id] Fail Decode")
                }
            case .failure(let error):
                print("[/files/upload] Fail : \(error)")
            }
        }
    }
    
    private func requestRecognizeImage() {
        guard let url = imageServerURL else { return }
        
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
