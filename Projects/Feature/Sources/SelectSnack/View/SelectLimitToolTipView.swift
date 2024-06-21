//
//  SelectLimitToolTipView.swift
//  Feature
//
//  Created by 김유진 on 2023/12/03.
//

import DesignSystem
import UIKit

final class SelectLimitToolTipView: UIView {
    
    private lazy var roundedBackgroundView = UIView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = moderateScale(number: 10)
    }
    
    private lazy var triangleBackgroundView = UIView().then {
        let size = moderateScale(number: 8)
        let path = CGMutablePath()
        let shape = CAShapeLayer()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: size / 2, y: size / 2))
        path.addLine(to: CGPoint(x: size, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        shape.path = path
        shape.fillColor = UIColor.gray.cgColor
        
        $0.layer.insertSublayer(shape, at: 0)
    }
    
    private lazy var selectLimitLabel = UILabel().then {
        $0.text = "5개까지 고를 수 있어요!"
        $0.font = Font.regular(size: 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SelectLimitToolTipView {
    private func addViews() {
        addSubview(roundedBackgroundView)
        addSubview(triangleBackgroundView)
        
        roundedBackgroundView.addSubview(selectLimitLabel)
    }
    
    private func makeConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.width.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 20))
        }
        
        selectLimitLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        triangleBackgroundView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 8))
            $0.top.equalTo(roundedBackgroundView.snp.bottom)
            $0.bottom.centerX.equalToSuperview()
        }
    }
    
    func updateView(_ title: String) {
        selectLimitLabel.text = title
    }
}
