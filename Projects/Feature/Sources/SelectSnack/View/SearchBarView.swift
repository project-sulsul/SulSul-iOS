//
//  SearchBarView.swift
//  Feature
//
//  Created by 김유진 on 2023/12/03.
//

import DesignSystem
import UIKit

final class SearchBarView: UIView {
    
    private weak var delegate: SearchSnack?
    
    private lazy var backgroundView = UIView().then {
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var searchImageView = UIImageView().then {
        $0.image = UIImage(named: "common_search")
    }
    
    private lazy var searchTextField = UITextField().then {
        $0.addTarget(self, action: #selector(handleTextFieldDidChange), for: .editingChanged)
        $0.placeholder = "안주이름을 검색해보세요"
        $0.textColor = .white
    }
    
    init(delegate: SearchSnack) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        backgroundColor = DesignSystemAsset.black.color
        
        addViews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        backgroundView.layer.borderColor = DesignSystemAsset.gray400.color.cgColor
    }
    
    @objc private func handleTextFieldDidChange() {
        if let searchText = searchTextField.text {
            delegate?.searchSnackWith(searchText)
        }
    }
}

extension SearchBarView {
    private func addViews() {
        addSubview(backgroundView)
        backgroundView.addSubview(searchImageView)
        backgroundView.addSubview(searchTextField)
    }
    
    private func makeConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 18))
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
    }
}
