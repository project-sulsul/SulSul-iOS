//
//  BaseTopView.swift
//  DesignSystem
//
//  Created by 이범준 on 12/9/23.
//

import UIKit
import SnapKit
import Then

public final class BaseTopView: UIView {
    public lazy var backTouchableView = TouchableView()
    
    private lazy var backImageView = UIImageView().then {
        $0.image = UIImage(named: "common_leftArrow")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then({
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        addSubviews([backTouchableView])
        backTouchableView.addSubviews([backImageView, titleLabel])
        
        backTouchableView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        backImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(backImageView.snp.trailing).offset(moderateScale(number: 8))
        }
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
