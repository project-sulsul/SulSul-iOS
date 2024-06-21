//
//  ReportTableViewCell.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import UIKit
import DesignSystem

final class ReportCell: UICollectionViewCell {
    
    lazy var containerView = TouchableView()
    
    private lazy var cellBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.isHidden = true
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.textColor = .white
    }
    
    private lazy var checkImageView = UIImageView().then {
        $0.image = UIImage(named: "common_snackCheck")
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func bind(_ model: ReportSelectModel) {
        titleLabel.text = model.title.rawValue
        cellBackgroundView.isHidden = model.isChecked ? false : true
        checkImageView.isHidden = model.isChecked ? false : true
    }
    
    private func addViews() {
        addSubview(containerView)
        containerView.addSubview(cellBackgroundView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(checkImageView)
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cellBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        checkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}
