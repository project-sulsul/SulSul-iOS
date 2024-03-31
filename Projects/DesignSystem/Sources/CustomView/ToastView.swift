//
//  ToastView.swift
//  DesignSystem
//
//  Created by 이범준 on 12/29/23.
//

import UIKit
import Then
import SnapKit

public enum ToastType {
    case success
    case error
}

public final class ToastMessageView: UIView {
    
    private var toastType: ToastType = .success
    
    private lazy var backgroundView = UIView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 12)
    }
    
    private lazy var toastImageView = UIImageView().then({
        $0.image = UIImage(named: "common_circleCheck")
    })

    private lazy var titleLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.semiBold(size: 14)
        $0.numberOfLines = 0
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(toastType: ToastType?, title: String) {
        guard let toastType = toastType else { return }
        titleLabel.text = title
        self.toastType = toastType
        
        if toastType == .success {
            toastImageView.image = UIImage(named: "common_circleCheck")
        } else {
            toastImageView.image = UIImage(named: "common_circleError")
        }
    }
    
    private func addViews() {
        addSubviews([backgroundView])
        backgroundView.addSubviews([toastImageView,
                                    titleLabel])
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(moderateScale(number: -80))
        }
        toastImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 16))
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 24))
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(toastImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalTo(toastImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(moderateScale(number: -16))
        }
    }
}
