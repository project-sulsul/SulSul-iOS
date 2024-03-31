//
//  WriteTitleViewController.swift
//  Feature
//
//  Created by 김유진 on 2/15/24.
//

import UIKit
import DesignSystem
import Service

final class WriteTitleViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator?
    
    private lazy var images: [UIImage] = []
    private lazy var heightByLine: [Int: CGFloat] = [1: 36, 2: 72, 3: 108]
    private lazy var textViewTwoLineHeight: Int? = nil
    private lazy var thumnailIndex = 0
    
    private lazy var thumnailImageView = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray
        $0.clipsToBounds = true
    }
    
    private lazy var titlePlaceholderLabel = UILabel().then {
        $0.text = "여기에 제목을 입력해주세요."
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 24)
    }
    
    private lazy var titleTextView = UITextView().then {
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.textContainer.maximumNumberOfLines = 3
    }
    
    private lazy var imageScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var imageStackView = UIStackView().then {
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
        $0.layoutMargins = UIEdgeInsets(top: 0, left: moderateScale(number: 20), bottom: 0, right: moderateScale(number: 20))
        $0.isLayoutMarginsRelativeArrangement = true
    }
    
    private lazy var reSelectPhotoLabel = UILabel().then {
        $0.text = "사진을 다시 선택하고 싶어요."
        $0.textColor = DesignSystemAsset.gray400.color
        $0.font = Font.bold(size: 16)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let text = UserDefaultsUtil.shared.getFeedTitle() {
            titleTextView.text = text
        }
    }
    
    override func viewDidLayoutSubviews() {
        setTextViewUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let text = titleTextView.text {
            UserDefaultsUtil.shared.setFeedTitle(text)
            titlePlaceholderLabel.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderText("썸네일&제목입력", actionText: "다음")
        
        reSelectPhotoLabel.onTapped { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        actionButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if !(selfRef.titleTextView.text.replacingOccurrences(of: " ", with: "").isEmpty) {
                var thumnailFirstSort = selfRef.images
                let thumnail = thumnailFirstSort.remove(at: selfRef.thumnailIndex)
                thumnailFirstSort.insert(thumnail, at: 0)
                
                selfRef.coordinator?.moveTo(appFlow: AppFlow.tabBar(.common(.writeContent)), userData: ["images": thumnailFirstSort])
                
            } else {
                selfRef.showToastMessageView(toastType: .error, title: "제목을 입력해주세요")
            }
        }
    }
    
    func setSelectedImages(_ images: [UIImage]) {
        self.images = images
        
        images.enumerated().forEach { index, image in
            let imageView = SelectableImageView(image: image)
            
            if index == 0 {
                imageView.isSelected = true
                thumnailImageView.image = image
            }
            
            imageView.updateSelection()

            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 72))
            }
            
            imageView.onTapped { [weak self] in
                self?.imageScrollView.scrollRectToVisible(imageView.frame,
                                                          animated: true)
                self?.thumnailIndex = index
                self?.thumnailImageView.image = image
                self?.updateThumnailImage(index)
            }
            
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func updateThumnailImage(_ selectedIndex: Int) {
        imageStackView.arrangedSubviews.enumerated().forEach { index, imageView in
            guard let imageView = imageView as? SelectableImageView else { return }
            
            imageView.isSelected = (index == selectedIndex)
            imageView.updateSelection()
        }
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([
            thumnailImageView,
            imageScrollView,
            reSelectPhotoLabel,
            titlePlaceholderLabel,
            titleTextView
        ])
        
        imageScrollView.addSubview(imageStackView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        thumnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
            $0.size.equalTo(moderateScale(number: 353))
        }
        
        titlePlaceholderLabel.snp.makeConstraints {
            $0.trailing.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.bottom.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.leading.equalTo(thumnailImageView).inset(moderateScale(number: 22))
            $0.height.equalTo(moderateScale(number: 36))
        }
        
        titleTextView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 36))
        }
        
        imageScrollView.snp.makeConstraints {
            $0.top.equalTo(thumnailImageView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 72))
        }
        
        reSelectPhotoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 56))
        }
        
        imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setTextViewUI() {
        let numberOfLine = Int(titleTextView.contentSize.height / titleTextView.font!.lineHeight)
        guard let height = heightByLine[numberOfLine] else { return }
        
        titleTextView.snp.remakeConstraints {
            $0.leading.trailing.bottom.equalTo(thumnailImageView).inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: height))
        }
        
        titlePlaceholderLabel.isHidden = !titleTextView.text.isEmpty
    }
}

extension WriteTitleViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 30
    }
    
    func textViewDidChange(_ textView: UITextView) {
        setTextViewUI()
    }
}
