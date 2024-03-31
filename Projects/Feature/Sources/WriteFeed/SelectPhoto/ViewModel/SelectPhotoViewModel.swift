//
//  SelectPhotoViewModel.swift
//  Feature
//
//  Created by 김유진 on 2/8/24.
//

import UIKit
import Combine
import DesignSystem

final class SelectPhotoViewModel {
    
    private let photoUtil = PhotoAuthUtil()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var images: [UIImage] = []
    private var selection: [Bool] = []
    private var selectionIndex: [Int] = []
    private var lastSelectedIndex = 0
    
    // MARK: Input Subject
    var fetchImages = PassthroughSubject<Void, Never>()
    
    // MARK: Output Subject
    var updateData = PassthroughSubject<Void, Never>()
    
    init() {
        
        fetchImages
            .flatMap(photoUtil.shouldUpateData(_:))
            .sink { [weak self] images in
                self?.selection = Array(repeating: false, count: images.count)
                self?.images = images
                self?.updateData.send(())
            }
            .store(in: &cancelBag)
    }
    
    func galleryImages() -> [UIImage] {
        return images
    }
    
    func toggleSelection(_ index: IndexPath) {
        selection[index.item].toggle()
        
        if selection[index.item] {
            selectionIndex.append(index.item)
            lastSelectedIndex = index.item
        } else {
            selectionIndex.removeAll(where: { $0 == index.item })
            lastSelectedIndex = selectionIndex.isEmpty ? lastSelectedIndex : selectionIndex[selectionIndex.count - 1]
            updateData.send(())
        }
    }
    
    func selectStatus(_ selectedIndex: IndexPath) -> (Bool, String?) {
        var count: String? = nil
        
        selectionIndex.enumerated().forEach { index, value in
            if value == selectedIndex.item {
                count = "\(index + 1)"
            }
        }
        
        return (selection[selectedIndex.item], count)
    }
    
    func canSelectImage(_ index: IndexPath) -> Bool {
        // MARK: 선택된 이미지가 5개 이하이거나 사진 선택을 취소하는 경우
        return selectionIndex.count < 5 || selection[index.item]
    }
    
    func lastSelectedImage() -> UIImage {
        return images[lastSelectedIndex]
    }
    
    func selectedCount() -> Int {
        return selectionIndex.count
    }
    
    func selectedImage() -> [UIImage] {
        var selectedImages: [UIImage] = []
        
        selectionIndex.forEach { selectedIndex in
            selectedImages.append(images[selectedIndex])
        }
        
        return selectedImages
    }
}
