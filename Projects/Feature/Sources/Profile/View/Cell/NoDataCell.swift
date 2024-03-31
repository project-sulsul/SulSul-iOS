//
//  NoDataCell.swift
//  Feature
//
//  Created by 이범준 on 2024/01/09.
//

import UIKit
import SnapKit
import Then
import DesignSystem

enum NoDataType {
    case logOutMyFeed
    case logInMyFeed
    case likeFeed
}

final class NoDataCell: UICollectionViewCell {
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = moderateScale(number: 28)
        $0.distribution = .equalCentering
        $0.alignment = .center
    }
    private lazy var messageLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    private lazy var nextTouchableView = TouchableView().then({
        $0.backgroundColor = DesignSystemAsset.main.color
        $0.layer.cornerRadius = moderateScale(number: 10)
    })
    lazy var nextLabel = TouchableLabel().then({
        $0.textColor = DesignSystemAsset.gray200.color
        $0.font = Font.bold(size: 16)
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        addSubview(stackView)
        stackView.addArrangedSubviews([messageLabel,
                                      nextTouchableView])
        nextTouchableView.addSubview(nextLabel)
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        nextTouchableView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.equalTo(moderateScale(number: 156))
        }
        nextLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func updateView(withType type: NoDataType) {
        switch type {
        case .logOutMyFeed:
            messageLabel.text = "즐거운 여정이 시작될 시간!\n로그인 하고 첫 피드를 작성하러 가볼까요?"
            nextLabel.text = "로그인 하러 가기"
        case .logInMyFeed:
            messageLabel.text = "오늘 먹은 맛있는 조합\n기록하기만 하쇼"
            nextLabel.text = "피드 작성하러가기"
        case .likeFeed:
            messageLabel.text = "좋아요 표시한 피드가 없네요..."
            nextLabel.text = "피드 보러가기"
        }
    }
}
