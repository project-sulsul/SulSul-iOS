//
//  CompleteViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2023-12-19.
//

import DesignSystem
import UIKit

public final class CompleteViewController: BaseViewController {
    var username = "보라색하이볼"
    
    private lazy var topView = UIView().then {
        $0.frame = .zero
    }
    
    private lazy var bottomView = UIView().then {
        $0.frame = .zero
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = Font.bold(size: 32)
        $0.text = "완료!"
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var subtitleLabel = UILabel().then {
        $0.font = Font.medium(size: 18)
        $0.text = "\(username)님이 선택해주신 취향으로\n추천해드릴게요!"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.setLineHeight(28)
        $0.numberOfLines = 2
    }
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "complete")
    }
    
    private lazy var backButton = UIButton().then {
        $0.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        $0.setImage(UIImage(named: "left_arrow"), for: .normal)
    }
    
    private lazy var mainButton = UIButton().then {
        $0.addTarget(self, action: #selector(mainButtonDidTap), for: .touchUpInside)
        $0.backgroundColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.layer.cornerRadius = CGFloat(12)
        $0.setTitle("메인으로", for: .normal)
        $0.setTitleColor(DesignSystemAsset.gray200.color, for: .normal)
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        view.addSubviews([topView, imageView, bottomView])
        topView.addSubviews([backButton, titleLabel, subtitleLabel])
        bottomView.addSubview(mainButton)
    }
    
    public override func makeConstraints() {
        topView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview().inset(moderateScale(number: 16))
            $0.size.equalTo(moderateScale(number: 24))
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton)
            $0.top.equalTo(backButton.snp.bottom).offset(moderateScale(number: 16))
        }
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
        }
        imageView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(moderateScale(number: 91))
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 200))
        }
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 110))
        }
        mainButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 52))
        }
    }
}

// MARK: - Custom Method

extension CompleteViewController {
    @objc private func backButtonDidTap() {
        #warning("함께 먹는 안주 화면으로 이동하는 것을 구현해야 해요.")
    }
    @objc private func mainButtonDidTap() {
        #warning("메인 화면으로 이동하는 것을 구현해야 해요.")
    }
}
