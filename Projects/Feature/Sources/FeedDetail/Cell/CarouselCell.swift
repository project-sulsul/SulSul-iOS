//
//  CarouselCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import UIKit
import DesignSystem

final class CarouselCell: UICollectionViewCell {
    // MARK: - Properties
    //
    static let reuseIdentifier = "CarouselCell"
    
    // MARK: - Components
    //
    private lazy var imageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
    }
    
    private lazy var blendView = UIView(frame: .zero).then {
        $0.layer.backgroundColor = DesignSystemAsset.black.color.cgColor.copy(alpha: 0.2)
    }
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 20
        self.layer.borderColor = .none
        self.layer.borderWidth = .zero
        self.layer.masksToBounds = true
        
        self.backgroundView = imageView
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
}

// MARK: - Custom method
//
extension CarouselCell {
    func bind(with imageURLString: String) {
        if let imageURL = URL(string: imageURLString) {
            self.imageView.kf.setImage(with: imageURL)
            
            debugPrint("\(#fileID) - Image URL is available.")
        } else {
            self.imageView.image = nil
            self.imageView.layer.backgroundColor = DesignSystemAsset.gray900.color.cgColor
            
            debugPrint("\(#fileID) - Image URL is not available.")
        }
    }
    
    private func addViews() {
        self.addSubview(imageView)
        self.contentView.addSubview(blendView)
    }
    
    private func makeConstraints() {
        self.blendView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
