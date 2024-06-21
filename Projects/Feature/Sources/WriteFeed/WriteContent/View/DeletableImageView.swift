//
//  DeletableImageView.swift
//  Feature
//
//  Created by 김유진 on 2/20/24.
//

import UIKit
import DesignSystem

final class DeletableImageView: UIView {
    
    lazy var imageView = UIImageView()
    
    lazy var deleteBackView = UIView()
    
    private lazy var deleteImageView = UIImageView().then {
        $0.image = UIImage(named: "filled_clear")?.withTintColor(DesignSystemAsset.gray900.color)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(imageView)
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
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = moderateScale(number: 11.2)
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setDisplayDeleteIcon(_ isHidden: Bool = false) {
        deleteBackView.isHidden = isHidden
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
