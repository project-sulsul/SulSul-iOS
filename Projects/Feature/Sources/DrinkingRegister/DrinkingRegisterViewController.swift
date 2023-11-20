//
//  DrinkingRegisterViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/20.
//

import UIKit
import DesignSystem
import Then
import SnapKit

public class DrinkingRegisterViewController: BaseViewController {
    
    private lazy var containerView = UIView().then({
        $0.backgroundColor = .red
    })
    
    // MARK: - 커스텀으로 할지 label로 할지
    private lazy var questionTitleView = UIView().then({
        $0.backgroundColor = .blue
    })
    
    private lazy var drinkingCollectionView = UICollectionView().then({
        $0.backgroundColor = .yellow
    })
    
    private lazy var selectCompleteButton = TouchableView()
    
    private lazy var selectCompleteLabel = UILabel().then({
        $0.text = "선택 완료"
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        makeConstraints()
        setupIfNeeded()
    }
    public override func addViews() {
        view.addSubview(containerView)
        containerView.addSubviews([questionTitleView,
                                   drinkingCollectionView,
                                   selectCompleteButton])
        selectCompleteButton.addSubview(selectCompleteLabel)
    }
    public override func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.trailing.equalToSuperview().offset(moderateScale(number: -20))
        }
        questionTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 58))
            $0.leading.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 68))
        }
        drinkingCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 56))
            $0.
        }
        selectCompleteButton.snp.makeConstraints {
            $0.
        }
        
    }
    public override func setupIfNeeded() {
        
    }
}

