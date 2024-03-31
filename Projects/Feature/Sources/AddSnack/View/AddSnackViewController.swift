//
//  AddSnackViewController.swift
//  Feature
//
//  Created by 김유진 on 2024/01/02.
//

import UIKit
import Combine
import DesignSystem

public class AddSnackViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    private lazy var viewModel = AddSnackViewModel(userId: 0)
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_leftArrow")?.withTintColor(DesignSystemAsset.gray900.color), for: .normal)
    }
    
    private lazy var contentScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }
    
    private lazy var containerView = UIView()
    
    private lazy var noFindSnackTitleLabel = UILabel().then {
        $0.text = "찾는 안주가 없어요..."
        $0.font = Font.bold(size: 32)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "안녕하세요 000님!\n서비스 초기여서, 원하시는 안주가 많이 없죠..?\n아래에 원하셨던 안주 정보를 입력해주시면,\n더 다양한 안주를 추가할 수 있도록 술술팀이 열심히 달\n려보겠습니다. 조금만 기다려주세요!!\n\n-2023년이 한달 남은 순간에, 술술팀 드림 🎅🏻"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.setLineHeight(24, font: Font.medium(size: 16))
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var writeSnackInfoLabel = UILabel().then {
        $0.text = "안주 정보 입력"
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var snackNameLabel = UILabel().then {
        $0.text = "안주 이름 (필수)"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.setFontForText("(필수)", withFont: Font.regular(size: 16))
    }
    
    private lazy var snackWriteContainerView = UIView().then {
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.borderColor = DesignSystemAsset.gray900.color.cgColor
        $0.layer.cornerRadius = moderateScale(number: 10)
    }
    
    private lazy var snackWriteTextField = UITextField().then {
        $0.placeholder = "안주 이름을 입력해주세요"
        $0.delegate = self
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private lazy var selectCategoryLabel = UILabel().then {
        $0.text = "카테고리 선택 (선택)"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.setFontAndColorForText("(선택)", withFont: Font.regular(size: 16), textColor: DesignSystemAsset.gray400.color)
    }
    
    private lazy var selectCategoryContainerButton = UIButton().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.addTarget(self, action: #selector(tapSelectCategoryContainerButton), for: .touchUpInside)
    }
    
    private lazy var selectedCategoryLabel = UILabel().then {
        $0.text = "카테고리를 선택해주세요"
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var categoryArrowImageView = UIImageView().then {
        $0.image = UIImage(named: "common_downTriangle")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = DesignSystemAsset.gray400.color
    }
    
    private lazy var submitButton = UIButton().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.setTitle("제출하기", for: .normal)
        $0.isEnabled = false
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.setTitleColor(DesignSystemAsset.gray300.color, for: .normal)
        $0.addTarget(self, action: #selector(tabSubmitButton), for: .touchUpInside)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        backButton.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        bind()
    }
    
    private func bind() {
        viewModel.goNextPagePublisher()
            .sink { [weak self] _ in
                // TODO: 다음 화면으로 화면전환
            }.store(in: &cancelBag)
        
        viewModel.updateSelectedSnackSortPublisher()
            .sink { [weak self] selectedSnackSort in
                
                let isTextPlaceHolder = selectedSnackSort.contains("카테고리")
                self?.selectedCategoryLabel.text = selectedSnackSort
                self?.selectedCategoryLabel.textColor = isTextPlaceHolder ? DesignSystemAsset.gray400.color : DesignSystemAsset.gray900.color
                self?.categoryArrowImageView.tintColor = isTextPlaceHolder ? DesignSystemAsset.gray400.color : DesignSystemAsset.gray900.color
            }.store(in: &cancelBag)
    }
    
    @objc private func tapSelectCategoryContainerButton() {
        let vc = SnackBottomSheetViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false)
    }
    
    @objc private func tabSubmitButton() {
        let snackName = snackWriteTextField.text ?? ""
        let snackSort = selectedCategoryLabel.text!.contains("카테고리") ? nil : selectedCategoryLabel.text
        viewModel.submitAddedSnack(snackName, snackSort)
    }
    
    public override func addViews() {
        view.addSubview(backButton)
        view.addSubview(noFindSnackTitleLabel)
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(containerView)
        
        containerView.addSubviews([
            descriptionLabel,
            lineView,
            writeSnackInfoLabel,
            snackNameLabel,
            snackWriteContainerView,
            selectCategoryLabel,
            selectCategoryContainerButton,
            submitButton
        ])
        
        snackWriteContainerView.addSubview(snackWriteTextField)

        selectCategoryContainerButton.addSubview(selectedCategoryLabel)
        selectCategoryContainerButton.addSubview(categoryArrowImageView)
    }
    
    public override func makeConstraints() {
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 75))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        noFindSnackTitleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(noFindSnackTitleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
            $0.leading.equalTo(noFindSnackTitleLabel)
        }

        lineView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(moderateScale(number: 24))
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 8))
        }

        writeSnackInfoLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.equalTo(backButton)
        }

        snackNameLabel.snp.makeConstraints {
            $0.top.equalTo(writeSnackInfoLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalTo(backButton)
        }

        snackWriteContainerView.snp.makeConstraints {
            $0.top.equalTo(snackNameLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }

        snackWriteTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
        }

        selectCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(snackWriteContainerView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalTo(backButton)
        }

        selectCategoryContainerButton.snp.makeConstraints {
            $0.top.equalTo(selectCategoryLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }

        selectedCategoryLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
            $0.trailing.equalTo(categoryArrowImageView.snp.leading).offset(moderateScale(number: -8))
        }

        categoryArrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.size.equalTo(moderateScale(number: 32))
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(selectCategoryContainerButton.snp.bottom).offset(moderateScale(number: 135))
            $0.height.equalTo(moderateScale(number: 52))
            $0.leading.equalTo(backButton)
            $0.centerX.bottom.equalToSuperview()
        }
    }
}

extension AddSnackViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        snackWriteContainerView.layer.borderColor = DesignSystemAsset.gray300.color.cgColor

        submitButton.isHidden = true
        submitButton.snp.updateConstraints {
            $0.top.equalTo(selectCategoryContainerButton.snp.bottom).offset(moderateScale(number: 413))
        }
        
        contentScrollView.setContentOffset(CGPoint(x: 0, y: writeSnackInfoLabel.frame.origin.y - moderateScale(number: 16)),
                                           animated: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        snackWriteContainerView.layer.borderColor = DesignSystemAsset.gray900.color.cgColor
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" {
            submitButton.isEnabled = false
            submitButton.backgroundColor = DesignSystemAsset.gray100.color
        } else if textField.text != "" && submitButton.backgroundColor != DesignSystemAsset.yellow050.color {
            submitButton.isEnabled = true
            submitButton.backgroundColor = DesignSystemAsset.yellow050.color
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 30
    }
}

extension AddSnackViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        let scrollUp = translation.y > 0 ? false : true
        
        if !scrollUp {
            snackWriteTextField.resignFirstResponder()
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let selfRef = self else { return }
                
                selfRef.submitButton.isHidden = false
                selfRef.submitButton.snp.updateConstraints {
                    $0.top.equalTo(selfRef.selectCategoryContainerButton.snp.bottom).offset(moderateScale(number: 135))
                }
                
                selfRef.contentScrollView.layoutIfNeeded()
            })
        }
    }
}
