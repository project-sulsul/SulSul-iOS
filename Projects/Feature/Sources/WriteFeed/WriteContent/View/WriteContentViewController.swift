//
//  WriteContentViewController.swift
//  Feature
//
//  Created by 김유진 on 2/19/24.
//

import UIKit
import DesignSystem
import Combine
import Service

protocol OnSelectedValue {
    func selectedValue(_ value: [String: Any])
}

open class WriteContentViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var cancelBag = Set<AnyCancellable>()
    var coordinator: CommonBaseCoordinator?
    
    private lazy var viewModel = WriteContentViewModel()
    private lazy var images: [UIImage] = []
    
    private lazy var imageScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
        $0.layoutMargins = UIEdgeInsets(top: 0, left: moderateScale(number: 20), bottom: 0, right: moderateScale(number: 20))
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var recognizedStackView = UIStackView().then {
        $0.distribution = .fill
        $0.spacing = moderateScale(number: 4)
    }
    
    private lazy var recognizedTitleLabel = UILabel().then {
        $0.text = "인식된 술&안주"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
        $0.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
    }
    
    private lazy var recognizedContentLabel = UILabel().then {
        $0.text = "AI가 열심히 찾고있어요!"
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.medium(size: 16)
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .right
    }
    
    private lazy var drinkSnackStackView = UIStackView().then {
        $0.distribution = .fillProportionally
        $0.isHidden = true
    }
    
    private lazy var recognizedDrinkLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.medium(size: 16)
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .right
    }
    
    private lazy var andLabel = UILabel().then {
        $0.text = "&"
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.medium(size: 16)
        $0.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
    }
    
    private lazy var recognizedSnackLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.medium(size: 16)
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .left
    }
    
    private lazy var recognizedImageView = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_progress")
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 16)
    }
    
    open lazy var contentTextView = UITextView().then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.font = Font.medium(size: 16)
        $0.delegate = self
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var placeholderLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.font = Font.medium(size: 16)
        $0.textColor = DesignSystemAsset.gray300.color
        $0.text = "내용을 입력해주세요.\n#를 눌러 태그를 추가할 수 있어요."
    }
    
    open lazy var tagContainerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.isHidden = true
    }
    
    open lazy var tagTextView = UITextView().then {
        $0.text = "#"
        $0.isScrollEnabled = false
        $0.font = Font.medium(size: 14)
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var iconContainerView = UIView()
    private lazy var iconLineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray200.color
    }
    
    private lazy var imageAddButton = UIView()
    private lazy var imageAddImageView = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_addImage")
    }
    
    private lazy var tagAddButton = UIView()
    private lazy var tagAddImageView = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_addTag")
    }
    
    private lazy var infoEditView = InfoEditView(delegate: self).then {
        $0.isHidden = true
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        if let thumnailImage = images.first {
            viewModel.uploadImage(thumnailImage)
            
            recognizedContentLabel.text = "AI가 열심히 찾고있어요!"
            recognizedImageView.image = UIImage(named: "writeFeed_progress")
        }
        
        if let text = UserDefaultsUtil.shared.getFeedContent() {
            contentTextView.text = text
            setTextViewUI()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        if let text = contentTextView.text {
            UserDefaultsUtil.shared.setFeedContent(text)
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        setHeaderText("내용입력", actionText: "게시", actionColor: DesignSystemAsset.gray300.color)
        setTabEvents()
    }
    
    private func bind() {
        changedKeyboardHeight
            .sink { [weak self] height in
                guard let selfRef = self else { return }
                
                let inset = (height == 0) ? 34 : (height + moderateScale(number: 24))
                
                selfRef.iconContainerView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(moderateScale(number: inset))
                }
            }
            .store(in: &cancelBag)
        
        viewModel.completeRecognizeAI
            .sink { [weak self] recognized in
                if let firstSnack = recognized.foods.first,
                   let firstDrink = recognized.alcohols.first {
                    self?.recognizedContentLabel.isHidden = true
                    self?.drinkSnackStackView.isHidden = false
                    self?.recognizedDrinkLabel.text = "\(firstDrink)"
                    self?.recognizedSnackLabel.text = "\(firstSnack)"
                    self?.recognizedImageView.image = UIImage(named: "writeFeed_rightArrow")
                    
                } else {
                    self?.recognizedContentLabel.isHidden = false
                    self?.drinkSnackStackView.isHidden = true
                    self?.recognizedContentLabel.text = "정보 직접 입력하기"
                    self?.recognizedImageView.image = UIImage(named: "writeFeed_rightArrow")
                    
                    self?.showAlertView(withType: .verticalTwoButton,
                                        title: "앗! 인식하지 못했어요.",
                                        description: "썸네일로 선택한 사진에서 술 & 안주 정보를 인식하지 못했어요. 사진을 변경하거나 정보를 직접 입력해주세요.",
                                        cancelText: "사진을 변경할게요",
                                        submitText: "정보를 직접 입력할게요",
                                        isSubmitColorYellow: true,
                                        submitCompletion: {
                        self?.infoEditView.bind(recognized)
                        self?.infoEditView.isHidden = false
                        
                    }, cancelCompletion: {
                        if let galleryVC = self?.coordinator?.currentNavigationViewController?.viewControllers[1] {
                            self?.coordinator?.currentNavigationViewController?.popToViewController(galleryVC, animated: true)
                        }
                    })
                }
            }
            .store(in: &cancelBag)
    }
    
    private func setTabEvents() {
        tagAddButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if selfRef.tagContainerView.isHidden {
                self?.tagTextView.text = "#"
                self?.tagTextView.becomeFirstResponder()
                self?.tagContainerView.isHidden = false
                
            } else {
                let lastText = selfRef.tagTextView.text.suffix(1)
                
                if lastText == " " {
                    selfRef.tagTextView.text = "\(selfRef.tagTextView.text ?? "")#"
                } else if lastText != " " && lastText != "#" {
                    selfRef.tagTextView.text = "\(selfRef.tagTextView.text ?? "") #"
                }
            }
        }
        
        imageAddButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if selfRef.images.count == 5 {
                selfRef.showToastMessageView(toastType: .error, title: "5개 이상 선택할수 없어요")
            } else {
                if let galleryVC = selfRef.coordinator?.currentNavigationViewController?.viewControllers[1] {
                    self?.coordinator?.currentNavigationViewController?.popToViewController(galleryVC, animated: true)
                }
            }
        }
        
        actionButton.onTapped { [weak self] in
            guard let selfRef = self,
                  let snack = selfRef.recognizedSnackLabel.text,
                  let drink = selfRef.recognizedDrinkLabel.text else { return }
            
            let isTextEmpty = selfRef.contentTextView.text.isEmpty
            
            if !isTextEmpty {
                let vc = ScoreBottomSheetViewController(snack: snack, drink: drink)
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
        }
        
        recognizedStackView.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if selfRef.recognizedContentLabel.text != "AI가 열심히 찾고있어요!" {
                self?.infoEditView.isHidden = false
            }
        }
    }
    
    func setSelectedImages(_ images: [UIImage]) {
        self.images = images
        
        images.enumerated().forEach { index, image in
            let imageView = DeletableImageView(image: image)
            
            if index == 0 {
                imageView.setDisplayDeleteIcon(true)
            }

            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 98))
            }
            
            imageStackView.addArrangedSubview(imageView)
            
            imageView.onTapped { [weak self] in
                self?.images.removeAll(where: { $0 == image })
                imageView.removeFromSuperview()
            }
        }
    }
    
    open override func addViews() {
        super.addViews()
        
        view.addSubviews([
            imageScrollView,
            recognizedTitleLabel,
            recognizedStackView,
            lineView,
            contentStackView,
            placeholderLabel,
            iconContainerView,
            infoEditView
        ])
        
        drinkSnackStackView.addArrangedSubviews([
            recognizedDrinkLabel,
            andLabel,
            recognizedSnackLabel
        ])
        
        recognizedStackView.addArrangedSubviews([
            recognizedContentLabel,
            drinkSnackStackView,
            recognizedImageView
        ])
        
        contentStackView.addArrangedSubviews([
            contentTextView,
            tagContainerView
        ])
        
        tagContainerView.addSubview(tagTextView)
        
        iconContainerView.addSubviews([
            iconLineView,
            imageAddButton,
            tagAddButton
        ])
        
        imageAddButton.addSubview(imageAddImageView)
        tagAddButton.addSubview(tagAddImageView)
        
        imageScrollView.addSubview(imageStackView)
    }
    
    open override func makeConstraints() {
        super.makeConstraints()
        
        infoEditView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 98))
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        recognizedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        recognizedStackView.snp.makeConstraints {
            $0.leading.equalTo(recognizedTitleLabel.snp.trailing).offset(moderateScale(number: 12))
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalTo(recognizedTitleLabel)
        }
        
        recognizedImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(recognizedTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 10))
            $0.width.centerX.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentTextView).offset(moderateScale(number: 7))
        }
        
        contentTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(placeholderLabel).offset(moderateScale(number: 8))
        }
        
        tagTextView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(moderateScale(number: 19))
            $0.edges.equalToSuperview().inset(moderateScale(number: 10))
        }
        
        iconContainerView.snp.makeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 34))
            $0.height.equalTo(moderateScale(number: 48))
        }

        iconLineView.snp.makeConstraints {
            $0.top.width.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 2))
        }
        
        imageAddButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
            $0.size.equalTo(moderateScale(number: 40))
            $0.centerY.equalToSuperview()
        }
        
        tagAddButton.snp.makeConstraints {
            $0.leading.equalTo(imageAddButton.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 40))
        }
        
        imageAddImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        tagAddImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
    }
}

extension WriteContentViewController: UITextViewDelegate {
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == tagTextView {
            // MARK: " " + " " 막기
            let isLastSpace = textView.text.suffix(1) == " "
            let isLast2Space = isLastSpace && text == " "
            
            // MARK: # + " " 입력 막기
            let isLastTag = textView.text.suffix(1) == "#"
            let isLastTagAndSpace = isLastTag && text == " "
            
            // MARK: 태그 연속 입력 막기
            let isLastTagAndTag = isLastTag && text == "#"
            
            return !isLast2Space && !isLastTagAndSpace && !isLastTagAndTag
            
        } else {
            if text == "#" {
                tagTextView.text = "#"
                tagTextView.becomeFirstResponder()
                tagContainerView.isHidden = false
                return false
            }
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            
            if !(numberOfChars <= 500) {
                showToastMessageView(toastType: .error, title: "500자 까지 입력 가능해요.")
            }
            
            return numberOfChars <= 500
        }
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        if textView == tagTextView {
            if textView.text.isEmpty {
                tagContainerView.isHidden = true
                contentTextView.becomeFirstResponder()
                
            } else {
                let last2Text = textView.text.suffix(2)
                let firstText = last2Text.prefix(1)
                let lastText = last2Text.suffix(1)
                
                // MARK: " " + "글자" 입력할 시 자동으로 # 추가
                if firstText == " " && lastText != "#" {
                    let textAddedTag = "\(textView.text.dropLast())#\(lastText)"
                    textView.text = textAddedTag
                }
                
                // MARK: "글자" + "#" 입력할 시 자동으로 " " 추가
                if lastText == "#" && firstText != " " {
                    let textAddedSpace = "\(textView.text.dropLast()) #"
                    textView.text = textAddedSpace
                }
            }
            
        } else if textView == contentTextView {
            setTextViewUI()
        }
    }
    
    private func setTextViewUI() {
        let isTextEmpty = contentTextView.text.isEmpty
        placeholderLabel.isHidden = !isTextEmpty
        
        if isTextEmpty {
            changeActionColor(DesignSystemAsset.gray300.color)
        } else {
            changeActionColor(DesignSystemAsset.main.color)
        }
    }
}

extension WriteContentViewController: OnSelectedValue {
    func selectedValue(_ value: [String : Any]) {
        guard let writtenText = value["writtenText"] as? [String] else { return }
        
        recognizedContentLabel.isHidden = true
        drinkSnackStackView.isHidden = false
        recognizedDrinkLabel.text = "\(writtenText[0])"
        recognizedSnackLabel.text = "\(writtenText[1])"
    }
}
