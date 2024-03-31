//
//  PageTabBarCell.swift
//  DesignSystem
//
//  Created by Yujin Kim on 2024-01-12.
//

import UIKit

/// 뷰 컨트롤러를 전환해주는 탭바 컴포넌트
open class PageTabBarCell: UICollectionViewCell {
    public static let reuseIdentifier = "PageTabBarCell"
    
    // MARK: - Custom Property
    
    private let selectedColor = DesignSystemAsset.main.color
    private let unselectedColor = DesignSystemAsset.gray300.color
    private let selectedFontSize = Font.bold(size: 18)
    private let unselectedFontSize = Font.medium(size: 18)
    
    private lazy var indicatorView = UIView().then {
        $0.frame = .zero
        $0.backgroundColor = unselectedColor
    }
    private lazy var titleLabel = UILabel().then {
        $0.frame = .zero
        $0.font = unselectedFontSize
        $0.textColor = unselectedColor
        $0.setLineHeight(28, font: Font.regular(size: 18))
    }
    
    open var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? selectedFontSize : unselectedFontSize
            titleLabel.textColor = isSelected ? selectedColor : unselectedColor
            
            indicatorView.backgroundColor = isSelected ? selectedColor : unselectedColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
    }
    
    // MARK: - Custom Method
    
    private func addViews() {
        self.contentView.addSubviews([titleLabel, indicatorView])
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 2))
        }
    }
}
