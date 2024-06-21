//
//  RewriteContentViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-05-19.
//

import UIKit
import Combine
import DesignSystem
import Photos

final class RewriteContentViewController: BaseHeaderViewController {
    // MARK: - Properties
    //
    private var feedID: Int
    private var originTitle: String
    private var originContent: String
    private var originRepresentImage: String
    private var originImages: [String]
    private var originUserTags: [String]
    
    private var cancelBag = Set<AnyCancellable>()
    private var imagePickerController: ImagePickerProtocol?
    private var viewModel: RewriteContentViewModel

    // MARK: - UI Components
    //
    private lazy var representImageView = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .darkGray
        $0.clipsToBounds = true
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
    
    private lazy var contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 16)
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 8.0
    }
    
    private lazy var tagContainerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.isHidden = true
    }
    
    private lazy var tagTextView = UITextView().then {
        $0.text = "#"
        $0.isScrollEnabled = false
        $0.font = Font.medium(size: 14)
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var imageAddButton = UIView()
    
    private lazy var imageAddImageView = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_addImage")
    }
    
    private lazy var tagAddButton = UIView()
    
    private lazy var tagAddImageView = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_addTag")
    }
    
    private lazy var userTagsTextField = UITextField().then {
        $0.placeholder = "User Tags (comma separated)"
        $0.borderStyle = .roundedRect
    }
    
    private lazy var saveButton = UIButton(type: .system).then {
        $0.setTitle("피드 수정하기", for: .normal)
        $0.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    // MARK: - Initializer
    //
    init(
        feedID: Int,
        title: String,
        content: String,
        representImage: String,
        images: [String],
        userTags: [String]
    ) {
        self.feedID = feedID
        self.originTitle = title
        self.originContent = content
        self.originRepresentImage = representImage
        self.originImages = images
        self.originUserTags = userTags
        
        self.viewModel = RewriteContentViewModel()
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Life-cycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setHeaderText("피드 수정", actionText: "완료")
        
        self.bind()
        print("originImages: \(originImages)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func addViews() {
        self.imageScrollView.addSubview(self.imageStackView)
        self.tagContainerView.addSubview(self.tagTextView)
        
        self.contentStackView.addArrangedSubviews([
            self.contentTextView,
            self.userTagsTextField
        ])
        
        self.view.addSubviews([
            self.representImageView,
            self.titleTextView,
            self.imageScrollView,
            self.contentTextView,
            self.userTagsTextField,
            self.saveButton
        ])
    }
    
    override func makeConstraints() {
        self.representImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 353))
        }
        
        self.titleTextView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(self.representImageView).inset(moderateScale(number: 16))
            $0.height.equalTo(moderateScale(number: 36))
        }
        
        self.imageScrollView.snp.makeConstraints {
            $0.top.equalTo(self.representImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 98))
        }
        
        self.imageStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        self.contentStackView.snp.makeConstraints {
            $0.top.equalTo(self.imageScrollView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        self.userTagsTextField.snp.makeConstraints {
            $0.top.equalTo(imageScrollView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        self.saveButton.snp.makeConstraints {
            $0.top.equalTo(userTagsTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}

// MARK: - Custom method
//
extension RewriteContentViewController {
    private func bind() {
        guard let representImageURLString = URL(string: self.originRepresentImage)
        else {
            print("Invalid URL: \(self.originRepresentImage)")
            return
        }
        self.representImageView.kf.setImage(with: representImageURLString)
        
        self.titleTextView.text = originTitle
        
        contentTextView.text = originContent
        userTagsTextField.text = originUserTags.joined(separator: ", ")
                
        originImages.forEach { imageUrl in
            guard let url = URL(string: imageUrl) else {
                print("Invalid URL: \(imageUrl)")
                return
            }
            
            let imageView = DeletableImageView()
            imageView.imageView.kf.setImage(with: url)
            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 98))
            }
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    // MARK: - Actions
    //
    @objc private func saveButtonTapped() {
        if let title = titleTextView.text, !title.isEmpty,
           let content = contentTextView.text, !content.isEmpty {
            self.viewModel.updateFeed(
                feedID: self.feedID,
                title: title,
                content: content,
                images: self.originImages,
                userTags: self.originUserTags
            )
        }
    }
}

// MARK: - UITextView Delegate
//
extension RewriteContentViewController: UITextViewDelegate {
    
}

// MARK: - BSImagePicker Delegate
//
extension RewriteContentViewController: ImagePickerDelegate {
    func didSelect(assets: [PHAsset]?, deletedAssets: [PHAsset]?) {}
}
