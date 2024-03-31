//
//  DeletableImageView.swift
//  Feature
//
//  Created by 김유진 on 2/20/24.
//

import UIKit
import DesignSystem

final class DeletableImageView: UIImageView {
    private lazy var deleteBackView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var deleteImageView = UIImageView().then {
        $0.image = UIImage(named: "filled_clear")?.withTintColor(DesignSystemAsset.gray900.color)
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        addSubview(deleteBackView)
        deleteBackView.addSubview(deleteImageView)
        
        deleteBackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 25))
        }
        
        deleteImageView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(moderateScale(number: 4.2))
            $0.size.equalTo(moderateScale(number: 16.68))
        }
        
        layer.cornerRadius = moderateScale(number: 11.2)
        clipsToBounds = true
    }
    
    func setDisplayDeleteIcon(_ isHidden: Bool = false) {
        deleteBackView.isHidden = isHidden
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
