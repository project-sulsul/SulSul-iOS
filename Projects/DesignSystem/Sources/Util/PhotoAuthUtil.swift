//
//  PhotoAuthUtil.swift
//  DesignSystem
//
//  Created by 김유진 on 2/8/24.
//

import UIKit
import Photos
import Combine

public class PhotoAuthUtil {
    private var photoLoadResult: PHFetchResult<PHAsset>?
    private var allPhotoImage: [UIImage] = []
    private var photoWidth = (UIScreen.main.bounds.width - 17.01) / 4
    private lazy var photoSize = CGSize(width: photoWidth, height: photoWidth)

    // MARK: output
    private var allImagesLoaded = CurrentValueSubject<[UIImage], Never>([])
    
    public init() {
        requestGalleryAuth { [weak self] in
            self?.fetchAllPhotos()
        }
    }
    
    private func fetchAllPhotos() {
        photoLoadResult = PHAsset.fetchAssets(with: nil)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        
        photoLoadResult?.enumerateObjects { [weak self] (asset, _, _) in
            guard let selfRef = self else { return }
            
            PHImageManager().requestImage(for: asset, targetSize: selfRef.photoSize, contentMode: .aspectFill, options: requestOptions) { [weak self] (image, info) in
                
                guard let selfRef = self,
                      let image = image else { return }
                
                selfRef.allPhotoImage.append(image)
                
                if selfRef.allPhotoImage.count == selfRef.photoLoadResult?.count {
                    selfRef.allImagesLoaded.send(selfRef.allPhotoImage)
                }
            }
        }
    }
    
    private func requestGalleryAuth(_ completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .limited:
                completion()
            case .authorized:
                completion()
            default:
                print("[Fail] Gallery image load")
            }
        }
    }
    
    public func shouldUpateData(_: Void) -> AnyPublisher<[UIImage], Never> {
        return allImagesLoaded.dropFirst().eraseToAnyPublisher()
    }
    
    public func galleryImages() -> [UIImage] {
        return allPhotoImage
    }
}
