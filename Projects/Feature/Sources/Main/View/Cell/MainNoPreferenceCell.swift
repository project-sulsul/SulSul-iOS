//
//  MainNoPreferenceCell.swift
//  Feature
//
//  Created by 이범준 on 3/1/24.
//

import UIKit
import DesignSystem

final class MainNoPreferenceCell: UICollectionViewCell {
    
    private lazy var feedImageView = UIImageView()
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "000님이\n소주와 함께 즐겼던\n특별한 순간을 공유해주실래요?"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 24)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    })
    
    lazy var registerButton = IndicatorTouchableView().then {
        $0.text = "첫 게시물 작성해보기"
        $0.setClickable(true)
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addViews() {
        addSubviews([feedImageView,
                     titleLabel,
                     registerButton])
    }
    
    private func makeConstraints() {
        feedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 75.5))
            $0.centerX.equalToSuperview()
        }
        registerButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.equalTo(moderateScale(number: 180))
        }
    }
    
    func bind(nickName: String?, preference: String) {
        let connectiveParticle = postPositionText(preference)
        
        if let nickName = nickName {
            titleLabel.text = "\(nickName)님이\n\(connectiveParticle) 함께 즐겼던\n특별한 순간을 공유해주실래요?"
        } else {
            titleLabel.text = "\(connectiveParticle) 함께 즐겼던\n특별한 순간을 공유해주실래요?"
        }
    }

    private func postPositionText(_ word: String) -> String {
        guard let lastText = word.last else { return word }
        let unicodeVal = UnicodeScalar(String(lastText))?.value
        guard let value = unicodeVal else { return word }
        if (value < 0xAC00 || value > 0xD7A3) { return word }
        let last = (value - 0xAC00) % 28
        let str = last > 0 ? "과" : "와"
        
        return word + str
    }
}
