//
//  RecognizedEditViewController.swift
//  Feature
//
//  Created by 김유진 on 3/30/24.
//

import UIKit
import DesignSystem

final class RecognizedEditViewController: BaseHeaderViewController {
    weak var delegate: OnSelectedValue?
    
    var selectedDrink: SnackModel?
    var selectedSnack: SnackModel?
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "인식된 술, 안주 정보를 수정할 수 있어요."
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkLabel = UILabel().then {
        $0.text = "술"
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var drinkBackView = UIView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = DesignSystemAsset.gray050.color
    }
    
    private lazy var placeholderLabel = UILabel().then {
        $0.text = "술 종류를 선택해주세요"
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var drinkArrowImageView = UIImageView().then {
        $0.image = UIImage(named: "common_downTriangle")?.withTintColor(DesignSystemAsset.gray400.color)
    }
    
    private lazy var snackLabel = UILabel().then {
        $0.text = "안주"
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var snackBackView = UIView().then {
        $0.layer.borderColor = DesignSystemAsset.gray400.color.cgColor
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var searchImageView = UIImageView().then {
        $0.image = UIImage(named: "common_search")?.withTintColor(DesignSystemAsset.gray400.color)
    }
    
    private lazy var snackPlaceholderLabel = UILabel().then {
        $0.text = "안주이름을 검색해보세요"
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var saveButton = UILabel().then {
        $0.text = "변경 내용 저장"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray300.color
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.textAlignment = .center
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderText("술&안주 정보 수정", actionText: "초기화")
        
        drinkBackView.onTapped { [weak self] in
            let vc = SelectDrinkBottomSheetViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            self?.present(vc, animated: false)
        }
        
        snackBackView.onTapped { [weak self] in
            let vc = SelectRecognizdSnackBottomSheet()
            vc.delegate = self
            let viewController = UINavigationController(rootViewController: vc)
            
            viewController.modalPresentationStyle = .fullScreen
            self?.present(viewController, animated: true)
        }
        
        saveButton.onTapped { [weak self] in
            self?.delegate?.selectedValue(["selectedDrink": self?.selectedDrink,
                                           "selectedSnack": self?.selectedSnack])
            self?.navigationController?.popViewController(animated: true)
        }
        
        actionButton.onTapped { [weak self] in
            self?.selectedDrink = nil
            self?.selectedSnack = nil
       
            self?.placeholderLabel.text = "안주이름을 검색해보세요"
            self?.placeholderLabel.textColor = DesignSystemAsset.gray400.color
      
            self?.snackPlaceholderLabel.text = "안주이름을 검색해보세요"
            self?.snackPlaceholderLabel.textColor = DesignSystemAsset.gray400.color

            self?.saveButton.textColor = DesignSystemAsset.gray300.color
            self?.saveButton.backgroundColor = DesignSystemAsset.gray100.color
        }
    }
    
    func bind(_ recognized: WriteContentModel.Recognized) {
        if let drink = recognized.alcohols.first {
            placeholderLabel.text = drink
            placeholderLabel.textColor = DesignSystemAsset.gray900.color
        }
        
        if let snack = recognized.foods.first {
            snackPlaceholderLabel.text = snack
            snackPlaceholderLabel.textColor = DesignSystemAsset.gray900.color
        }
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        drinkLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalTo(descriptionLabel)
        }
        
        drinkBackView.snp.makeConstraints {
            $0.top.equalTo(drinkLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
        
        drinkArrowImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 32))
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        snackLabel.snp.makeConstraints {
            $0.top.equalTo(drinkBackView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalTo(drinkLabel)
        }
        
        snackBackView.snp.makeConstraints {
            $0.size.equalTo(drinkBackView)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(snackLabel.snp.bottom).offset(moderateScale(number: 8))
        }
        
        searchImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        snackPlaceholderLabel.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(moderateScale(number: 42))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
            $0.centerX.equalToSuperview()
        }
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([
            descriptionLabel,
            drinkLabel,
            drinkBackView,
            snackLabel,
            snackBackView,
            saveButton
        ])
        
        drinkBackView.addSubviews([
            placeholderLabel,
            drinkArrowImageView
        ])
        
        snackBackView.addSubviews([
            snackPlaceholderLabel,
            searchImageView
        ])
    }
}

extension RecognizedEditViewController: OnSelectedValue {
    func selectedValue(_ value: [String : Any]) {
        if let selectedDrink = value["selectedDrink"] as? SnackModel {
            placeholderLabel.text = selectedDrink.name
            placeholderLabel.textColor = DesignSystemAsset.gray900.color
            self.selectedDrink = selectedDrink
        }
        
        if let selectedSnack = value["selectedSnack"] as? SnackModel {
            snackPlaceholderLabel.text = selectedSnack.name
            snackPlaceholderLabel.textColor = DesignSystemAsset.gray900.color
            self.selectedSnack = selectedSnack
        }
        
        if self.selectedSnack != nil || self.selectedDrink != nil {
            
            saveButton.textColor = DesignSystemAsset.gray050.color
            saveButton.backgroundColor = DesignSystemAsset.main.color
        }
    }
}
