//
//  MainLikeFooterView.swift
//  Feature
//
//  Created by 이범준 on 3/2/24.
//

import UIKit
import DesignSystem

final class MainLikeFooterView: UICollectionReusableView {
    lazy var containerView = TouchableView()
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "더 많은 조합 보러가기!"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray400.color
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
        addSubview(containerView)
        containerView.addSubviews([titleLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
