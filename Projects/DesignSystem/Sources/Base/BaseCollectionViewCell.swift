//
//  BaseCollectionViewCell.swift
//  ut-global-ios
//
//  Created by 이범준 on 2023/11/23.
//

import UIKit

open class BaseCollectionViewCell<M>: UICollectionViewCell {
    open var model: M? {
        didSet {
            if let model = model {
                bind(model)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func bind(_ model: M) {}
}
