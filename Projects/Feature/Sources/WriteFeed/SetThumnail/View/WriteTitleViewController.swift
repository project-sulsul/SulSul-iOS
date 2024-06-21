//
//  WriteTitleViewController.swift
//  Feature
//
//  Created by 김유진 on 2/15/24.
//

import UIKit
import DesignSystem
import Service
import Photos
import BSImagePicker

final class WriteTitleViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator?
    
    private var imagePickerController: ImagePickerProtocol?
    
    private lazy var images: [UIImage] = []
    private lazy var heightByLine: [Int: CGFloat] = [1: 36, 2: 72, 3: 108]
    private lazy var textViewTwoLineHeight: Int? = nil
    private lazy var thumnailIndex = 0
    
    private lazy var thumnailImageView = UIImageView().then {
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .darkGray
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
        $0.textColor = DesignSystemAsset.gray700.color
        $0.font = Font.bold(size: 16)
    }
    
    private lazy var bottomGradientLayer = CAGradientLayer()
    
    private lazy var bottomGradientView = UIView().then {
        bottomGradientLayer.colors = [UIColor.clear.cgColor,
                                      DesignSystemAsset.black.color.withAlphaComponent(0.1),
                                      DesignSystemAsset.black.color.cgColor]
        bottomGradientLayer.opacity = 1
        bottomGradientLayer.locations = [0, 0.2]
        $0.layer.addSublayer(bottomGradientLayer)
        bottomGradientLayer.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: Int(moderateScale(number: 270)))
        $0.isHidden = true
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray500.color
        $0.numberOfLines = 0
        $0.setLineHeight(24,
                         text: "읽어주세요!\n• 제목과 함께 있는 이미지는 썸네일로 사용돼요.\n• 이미지는 최대 5장 까지만 선택할 수 있어요.",
                         font: Font.regular(size: 16))
    }
    
    private lazy var noticeView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color.withAlphaComponent(0.4)
        $0.layer.cornerRadius = 8
        
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        imageView.tintColor = DesignSystemAsset.main.color
        
        let label = UILabel()
        label.setLineHeight(18,
                            text: "서비스와 관련이 없는 부적절한 내용을 작성하는 경우,\n향후 관리자 조치로 계정 이용이 정지될 수 있습니다.",
                            font: Font.medium(size: 12))
        label.textColor = DesignSystemAsset.white.color
        label.numberOfLines = 0
        
        let moreLabel = TouchableLabel()
        moreLabel.setLineHeight(18,
                                text: "자세히",
                                font: Font.medium(size: 12),
                                hasUnderline: true)
        moreLabel.textColor = DesignSystemAsset.white.color
        
        moreLabel.onTapped {
            guard let url = URL(string: "https://mopil1102.notion.site/51b45ca9663843f89174798fb6f725e2?pvs=4") else { return }
            
            UIApplication.shared.open(url)
        }
        
        $0.addSubviews([
            imageView,
            label,
            moreLabel
        ])
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
        
        moreLabel.snp.makeConstraints {
            $0.leading.equalTo(label.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-moderateScale(number: 8))
        }
    }
    
    private lazy var addedImageView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.isHidden = true
    }
    
    private lazy var addImageView2 = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_addCircle")?.withTintColor(DesignSystemAsset.gray500.color)
    }
    
    private lazy var addImageView = UIImageView().then {
        $0.image = UIImage(named: "writeFeed_addCircle")?.withTintColor(DesignSystemAsset.gray500.color)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        imagePickerController = ImagePicker(presentationController: self,
                                            delegate: self,
                                            width: nil,
                                            maxSelectionChangeable: true)
        
        setHeaderText("썸네일&제목입력", actionText: "다음")
        
        actionButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if selfRef.titleTextView.text.replacingOccurrences(of: " ", with: "").isEmpty {
                selfRef.showToastMessageView(toastType: .error, title: "제목을 입력해주세요")
            } else if selfRef.thumnailImageView.image == nil {
                selfRef.showToastMessageView(toastType: .error, title: "이미지를 선택해주세요")
                
            } else  {
                var thumnailFirstSort = selfRef.images
                let thumnail = thumnailFirstSort.remove(at: selfRef.thumnailIndex)
                thumnailFirstSort.insert(thumnail, at: 0)
                
                selfRef.coordinator?.moveTo(appFlow: AppFlow.tabBar(.common(.writeContent)), userData: ["images": thumnailFirstSort])
            }
        }
        
        reSelectPhotoLabel.onTapped { [weak self] in
            self?.checkPermission()
        }
        
        thumnailImageView.onTapped { [weak self] in
            self?.checkPermission()
        }
        
        addedImageView.onTapped { [weak self] in
            self?.checkPermission()
        }
    }
    
    private func updateThumnailImage(_ selectedIndex: Int) {
        imageStackView.arrangedSubviews.enumerated().forEach { index, imageView in
            guard let imageView = imageView as? SelectableImageView else { return }
            
            imageView.isSelected = (index == selectedIndex + 1)
            imageView.updateSelection()
        }
    }
    
    private func setSelectedImages(_ images: [UIImage]) {
        self.images = images
        
        descriptionLabel.isHidden = images.count != 0
        addImageView.isHidden = images.count != 0
        addedImageView.isHidden = !(1...4).contains(images.count)
        
        images.enumerated().forEach { index, image in
            let imageView = SelectableImageView(image: image)
            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 72))
            }
            
            imageStackView.addArrangedSubview(imageView)

            if index == 0 {
                imageView.isSelected = true
                thumnailImageView.image = image
            }
            
            imageView.updateSelection()
            
            imageView.onTapped { [weak self] in
                self?.imageScrollView.scrollRectToVisible(imageView.frame,
                                                          animated: true)
                self?.thumnailIndex = index
                self?.thumnailImageView.image = image
                self?.updateThumnailImage(index)
            }
        }
    }
    
    override func addViews() {
        super.addViews()
        
        view.addSubviews([
            thumnailImageView,
            imageScrollView,
            reSelectPhotoLabel,
            titlePlaceholderLabel,
            titleTextView,
            descriptionLabel
        ])
        
        view.addSubview(noticeView)
        
        addedImageView.addSubview(addImageView2)
        
        thumnailImageView.addSubview(bottomGradientView)
        thumnailImageView.addSubview(addImageView)
        
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(addedImageView)
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        addImageView2.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 32))
            $0.center.equalToSuperview()
        }
        
        addImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 48))
            $0.center.equalToSuperview()
        }
        
        thumnailImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noticeView.snp.bottom).offset(moderateScale(number: 8))
            $0.size.equalTo(moderateScale(number: 353))
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(thumnailImageView.snp.bottom).offset(moderateScale(number: 32))
            $0.leading.trailing.equalTo(thumnailImageView)
        }
        
        bottomGradientView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(thumnailImageView).dividedBy(1.5)
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
        
        addedImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 72))
        }
        
        noticeView.snp.makeConstraints {
            $0.leading.trailing.equalTo(thumnailImageView)
            $0.top.equalTo(headerView.snp.bottom)
            $0.height.equalTo(moderateScale(number: 52))
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
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
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

extension WriteTitleViewController: ImagePickerDelegate {
    func didSelect(assets: [PHAsset]?,
                   deletedAssets: [PHAsset]?) {
        
        imageStackView.arrangedSubviews.forEach { image in
            image.removeFromSuperview()
            imageStackView.removeArrangedSubview(image)
        }
        imageStackView.addArrangedSubview(addedImageView)
        
        if assets == nil {
            thumnailImageView.image = nil
            descriptionLabel.isHidden = false
            addImageView.isHidden = false
            addedImageView.isHidden = true
            bottomGradientView.isHidden = true
            images = []
            
        } else {
            var images: [UIImage] = []
            
            assets?.forEach({ asset in
                asset.getUIImage(width: moderateScale(number: 353),
                                 height: moderateScale(number: 353)) { uiimage, _ in
                    images.append(uiimage)
                    
                    if images.count == assets?.count {
                        self.setSelectedImages(images)
                        self.bottomGradientView.isHidden = false
                    }
                }
            })
        }
    }
}

extension PHAsset {
    func getUIImage(width: CGFloat,
                    height: CGFloat, completion: @escaping (UIImage, Bool) -> Void) {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        
        options.isNetworkAccessAllowed = true
        options.isSynchronous = false
        options.version = .current
        options.deliveryMode = .highQualityFormat
        
        manager.requestImage(for: self,
                             targetSize: PHImageManagerMaximumSize,
                             contentMode: PHImageContentMode.aspectFit,
                             options: options) { (image, info) in
            
            let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool) ?? false
            
            DispatchQueue.main.async {
                let newWidth = width
                let height = height
                let scale = (image?.size.width ?? 1.0) / newWidth
                let newHeight = (image?.size.height ?? 1.0) / scale
                let newSize = CGSize(width: width, height: newHeight)
                let render = UIGraphicsImageRenderer(size: newSize)
                
                let renderImage = render.image { _ in
                    image?.draw(in: CGRect(origin: .zero, size: newSize))
                }
                
                img = renderImage
                guard let img = img else { return }
                completion(img, isDegraded)
            }
        }
    }
}

extension WriteTitleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .limited:
                PHPhotoLibrary.shared().register(self)
                let actionSheet = UIAlertController(title: "",
                                                    message: "더 많은 사진을 선택하거나 모든 사진에 대한 액세스를 허용하려면 설정으로 이동해주세요.",
                                                    preferredStyle: .actionSheet)
                
                let selectPhotosAction = UIAlertAction(title: "더 많은 사진 선택",
                                                       style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    if #available(iOS 15, *) {
                        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self) { [weak self] _ in
                            self?.imagePickerController?.present(max: 5)
                        }
                    } else {
                        imagePickerController?.present(max: 5)
                    }
                }
                actionSheet.addAction(selectPhotosAction)
                
                let allowFullAccessAction = UIAlertAction(title: "권한 설정으로 이동",
                                                          style: .default) { _ in
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                            UIApplication.shared.canOpenURL(settingsURL) else { return }
                    UIApplication.shared.open(settingsURL, completionHandler: nil)
                }
                actionSheet.addAction(allowFullAccessAction)
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
                    self?.imagePickerController?.present(max: 5)
                }
                actionSheet.addAction(cancelAction)
                
                present(actionSheet, animated: true, completion: nil)
                
            case .authorized:
                imagePickerController?.present(max: 5)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { [weak self] newStatus in
                    guard let selfRef = self else { return }
                    if newStatus == PHAuthorizationStatus.authorized {
                        selfRef.imagePickerController?.present(max: 5)
                    }
                }
            default:
                showAlertView(withType: .twoButton,
                              title: "알림",
                              description: "사진을 불러올 수 없습니다. \n사진 접근 권한을 허용해주세요.",
                              submitCompletion: {
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                          UIApplication.shared.canOpenURL(settingsURL) else { return }
                    UIApplication.shared.open(settingsURL, completionHandler: nil)
                }, cancelCompletion: nil)
            }
    }
}


extension WriteTitleViewController: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        LogDebug(changeInstance)
    }
}
