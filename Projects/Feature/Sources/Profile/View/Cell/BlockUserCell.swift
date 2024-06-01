//
//  BlockUserCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-06-01.
//

import UIKit
import DesignSystem

protocol BlockUserCellDelegate: AnyObject {
    func didTapUnblockTouchableLabel(at indexPath: IndexPath)
}

final class BlockUserCell: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    weak var delegate: BlockUserCellDelegate?
    var indexPath: IndexPath?
    
    private lazy var userImageView = UIImageView().then {
        $0.image = UIImage(named: "profile_notUser")
    }
    
    private lazy var userNameLabel = UILabel()
    
    private lazy var unblockTouchableView = TouchableView()
    
    private lazy var unblockLabel = UILabel().then {
        $0.setLineHeight(20, text: "차단해제", font: Font.bold(size: 14))
        $0.isUserInteractionEnabled = true
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom methods
//
extension BlockUserCell {
    func bind(_ model: BlockUser, at indexPath: IndexPath) {
        self.indexPath = indexPath
        
        if let imageURLString = model.image {
            self.setUserImage(imageURLString)
        }
        
        self.setUserNameLabel(model.name)
        
        self.unblockTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.delegate?.didTapUnblockTouchableLabel(at: indexPath)
        }
        
        self.addViews()
        self.makeConstraints()
    }
    
    private func addViews() {
        self.unblockTouchableView.addSubview(self.unblockLabel)
        
        self.addSubviews([
            self.userImageView,
            self.userNameLabel,
            self.unblockTouchableView
        ])
    }
    
    private func makeConstraints() {
        self.userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        self.userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(moderateScale(number: 10))
            $0.centerY.equalToSuperview()
        }
        self.unblockTouchableView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.top.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        self.unblockLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setUserNameLabel(_ name: String) {
        self.userNameLabel.setLineHeight(24, text: name, font: Font.regular(size: 18))
        self.userNameLabel.textColor = DesignSystemAsset.gray900.color
    }
    
    private func setUserImage(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        self.userImageView.kf.setImage(with: url)
        self.userImageView.layer.cornerRadius = 12
    }
}
