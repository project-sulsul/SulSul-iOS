//
//  CarouselView.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-19.
//

import UIKit
import DesignSystem

final class CarouselView: UIView {
    // MARK: - Components
    //
    private lazy var scrollView = UIScrollView().then {
        $0.clipsToBounds = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.delegate = self
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalCentering
        $0.spacing = 20
        $0.alignment = .fill
    }
    
    private lazy var imageView = UIImageView(frame: .zero).then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = .none
        $0.layer.borderWidth = .zero
        $0.layer.masksToBounds = true
    }
    
    private lazy var imageIndexLabel = PaddableLabel(edgeInsets: 4, 8, 4, 8).then {
        $0.setLineHeight(18, font: Font.regular(size: 12))
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
        $0.font = Font.regular(size: 12)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLineHeight(36, font: Font.bold(size: 24))
        $0.lineBreakMode = .byCharWrapping
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.white.color
        $0.sizeToFit()
    }
    
    private lazy var indicatorView = CarouselIndicatorView(frame: .zero)
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method

extension CarouselView {
    func bind(_ model: FeedDetail) {
        var feedImages = model.images
        feedImages.insert(model.representImage, at: 0)
        feedImages.forEach { image in
            if let imageURL = URL(string: image) {
                let blendView = UIView(frame: .zero).then {
                    $0.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.2)
                }
                let imageView = UIImageView(frame: .zero).then {
                    $0.contentMode = .scaleAspectFill
                    $0.layer.cornerRadius = 20
                    $0.layer.masksToBounds = true
                    $0.kf.setImage(with: imageURL)
                    $0.addSubview(blendView)
                }
                
                self.imageStackView.addArrangedSubview(imageView)
                
                blendView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                
                imageView.snp.makeConstraints {
                    $0.width.equalTo(self.scrollView.snp.width)
                    $0.height.equalTo(self.scrollView.snp.height)
                }
            } else {
                self.imageView.image = nil
            }
        }
        
        self.imageIndexLabel.text = "1/\(feedImages.count)"
        self.titleLabel.text = model.title
        
        self.indicatorView.widthRatio = 1.0 / Double(feedImages.count)
        
        self.indicatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.scrollView.snp.bottom).offset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 2))
        }
    }
    
    private func addViews() {
        self.scrollView.addSubview(self.imageStackView)
        
        self.addSubviews([
            self.scrollView,
            self.imageIndexLabel,
            self.titleLabel,
            self.indicatorView
        ])
        
        self.bringSubviewToFront(self.imageIndexLabel)
        self.bringSubviewToFront(self.titleLabel)
    }
    
    private func makeConstraints() {
        self.scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
        
        self.imageStackView.snp.makeConstraints {
            $0.leading.trailing.equalTo(self.scrollView.contentLayoutGuide)
        }
        
        self.imageIndexLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 18))
//            $0.top.equalToSuperview().offset(moderateScale(number: 239))
            $0.bottom.equalTo(self.titleLabel.snp.top).offset(-moderateScale(number: 4))
            $0.height.lessThanOrEqualTo(moderateScale(number: 22))
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 18))
            $0.bottom.equalToSuperview().offset(-moderateScale(number: 32))
        }
    }
    
    private func updateImageIndexLabel(_ currentIndex: Int, _ numberOfImages: Int) {
        self.imageIndexLabel.text = "\(currentIndex)/\(numberOfImages)"
    }
}

// MARK: - UIScrollView Delegate
//
extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.frame.size.width
        let currentIndex = Int(scrollView.contentOffset.x / scrollViewWidth)
        let imageViewWidth = scrollViewWidth + 20
        let targetContentOffsetX = CGFloat(currentIndex) * imageViewWidth
        
        // 스크롤 뷰의 컨텐츠 오프셋을 조정해서 스냅 효과 구현
        scrollView.setContentOffset(CGPoint(x: targetContentOffsetX, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 되었을 때마다 이미지 인디케이터가 움직이고 라벨 값을 갱신
        let scrollViewWidth = scrollView.frame.size.width
        let contentOffsetX = scrollView.contentOffset.x
        let currentIndex = Int(scrollView.contentOffset.x / scrollViewWidth) + 1
        let numberOfImages = self.imageStackView.arrangedSubviews.count
        let ratio = contentOffsetX / scrollViewWidth / Double(numberOfImages)
        
        self.updateImageIndexLabel(currentIndex, numberOfImages)
        self.indicatorView.updateLeadingOffsetRatio(ratio)
    }
}
