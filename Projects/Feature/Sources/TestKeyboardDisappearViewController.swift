//
//  TestKeyboardDisappearViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/21.
//

import UIKit
import DesignSystem

public final class InputBirthDayViewController: DisappearKeyBoardBaseViewController {
    
    private lazy var birthDayTextField = UITextField().then({
        $0.layer.borderColor = UIColor.purple.cgColor
        $0.layer.borderWidth = 1
    })
    
    public override func addViews() {
        super.addViews()
        
        view.addSubviews([birthDayTextField])
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        birthDayTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 100))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
    }
    
    public override func setupIfNeeded() {
        super.setupIfNeeded()
        
        submitTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            guard let selfRef = self else { return }
            print("확인 버튼 클릭")
        }
    }
}
