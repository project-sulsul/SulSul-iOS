//
//  MainLikeHeaderView.swift
//  Feature
//
//  Created by 이범준 on 3/2/24.
//

import UIKit
import DesignSystem

final class MainLikeHeaderView: UICollectionReusableView {
    private lazy var separatorView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.isHidden = false
    })
    private lazy var titleLabel = UILabel().then({
        $0.text = "좋아요 많은 조합"
        $0.font = Font.bold(size: 28)
        $0.textColor = DesignSystemAsset.gray900.color
    })
    private lazy var subTitleLabel = UILabel().then({
        $0.text = "자주, 늘 먹는데에는 이유가 있는 법!"
        $0.font = Font.medium(size: 14)
        $0.textColor = DesignSystemAsset.gray500.color
        $0.numberOfLines = 0
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DesignSystemAsset.black.color
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addViews() {
        addSubviews([separatorView,
                     titleLabel,
                     subTitleLabel])
    }
    
    private func makeConstraints() {
        separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 0))
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.leading.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview()
        }
    }
    
    func updateView(title: String, subTitle: String, separator: Bool = false) {
        if separator {
            separatorView.snp.updateConstraints {
                $0.height.equalTo(moderateScale(number: 12))
            }
        } else {
            separatorView.snp.updateConstraints {
                $0.height.equalTo(moderateScale(number: 0))
            }
        }
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
