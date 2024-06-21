//
//  SelectableImageView.swift
//  Feature
//
//  Created by 김유진 on 2/19/24.
//

import UIKit
import DesignSystem

final class SelectableImageView: UIImageView {
    var isSelected = false
    
    private lazy var blurView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        addSubview(blurView)
        
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        layer.borderWidth = moderateScale(number: 2)
        layer.borderColor = DesignSystemAsset.white.color.cgColor
        layer.cornerRadius = moderateScale(number: 12)
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
    func updateSelection() {
        layer.borderWidth = isSelected ? moderateScale(number: 2) : 0
        blurView.isHidden = isSelected
        
        isSelected.toggle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
