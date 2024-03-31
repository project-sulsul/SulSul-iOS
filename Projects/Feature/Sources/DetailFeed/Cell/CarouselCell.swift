//
//  CarouselCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-10.
//

import UIKit
import DesignSystem

final class CarouselCell: UICollectionViewCell {
    static let reuseIdentifier = "CarouselCell"
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage()
        $0.contentMode = .scaleToFill
    }
    
    private lazy var opaqueView = UIView().then {
        $0.frame = .zero
        $0.layer.backgroundColor = DesignSystemAsset.black.color.cgColor.copy(alpha: 0.2)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = CGFloat(20)
        self.layer.borderColor = .none
        self.layer.borderWidth = .zero
        self.layer.masksToBounds = true
        
        self.backgroundView = imageView
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ item: String) {
        if let imageURL = URL(string: item) {
            imageView.loadImage(imageURL)
        } else {
            print("Image URL is not available.")
            imageView.image = UIImage()
        }
    }
    
    private func addViews() {
        self.addSubview(imageView)
        self.contentView.addSubview(opaqueView)
    }
    
    private func makeConstraints() {
        opaqueView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
