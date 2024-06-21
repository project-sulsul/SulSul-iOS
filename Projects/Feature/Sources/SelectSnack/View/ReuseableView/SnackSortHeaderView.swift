//
//  SnackSortHeaderView.swift
//  Feature
//
//  Created by 김유진 on 2023/12/12.
//

import UIKit
import DesignSystem

final class SnackSortHeaderView: UITableViewHeaderFooterView {
    static let id = "\(SnackSortHeaderView.self)"
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
    }
    
    private lazy var snackSortImojiLabel = UILabel().then {
        $0.font = Font.bold(size: 14)
    }
    
    private lazy var snackSortLabel = UILabel().then {
        $0.font = Font.bold(size: 14)
        $0.textColor = .white
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ headerModel: SnackHeader) {
        snackSortImojiLabel.text = headerModel.snackHeaderImage
        snackSortLabel.text = headerModel.snackHeaderTitle
    }
}

extension SnackSortHeaderView {
    private func addViews() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubviews([snackSortImojiLabel, snackSortLabel])
    }
    
    private func makeConstraints() {
        contentStackView.snp.makeConstraints {
            $0.height.centerY.leading.equalToSuperview()
        }
    }
}
