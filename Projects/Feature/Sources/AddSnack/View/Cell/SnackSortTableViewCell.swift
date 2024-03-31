//
//  SnackSortTableViewCell.swift
//  Feature
//
//  Created by 김유진 on 2024/01/03.
//

import UIKit
import DesignSystem

final class SnackSortTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SnackSortTableViewCell"
    
    lazy var cellBackButton = TouchableView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var checkImageView = UIImageView().then {
        $0.image = UIImage(named: "common_snackCheck")
    }
    
    private lazy var snackSortLabel = UILabel().then {
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = DesignSystemAsset.gray100.color
        layout()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ snackSortModel: SnackSortModel) {
        snackSortLabel.text = snackSortModel.name
        cellBackButton.backgroundColor = snackSortModel.isSelect ? DesignSystemAsset.gray200.color : DesignSystemAsset.gray100.color
        checkImageView.isHidden = !snackSortModel.isSelect
    }
}

extension SnackSortTableViewCell {
    private func layout() {
        contentView.addSubview(cellBackButton)
        contentView.addSubview(snackSortLabel)
        contentView.addSubview(checkImageView)
        
        cellBackButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.top.equalToSuperview().inset(moderateScale(number: 2))
        }
        
        snackSortLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 16))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
