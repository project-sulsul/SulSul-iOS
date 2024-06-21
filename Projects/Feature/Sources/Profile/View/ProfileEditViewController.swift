//
//  EditProfileViewController.swift
//  Feature
//
//  Created by 이범준 on 2024/01/10.
//

import Combine
import UIKit
import DesignSystem
import MobileCoreServices
import AVFoundation
import Photos
import Mantis

public final class ProfileEditViewController: HiddenTabBarBaseViewController {
    
    var coordinator: MoreBaseCoordinator?
    private let viewModel = ProfileEditViewModel()
    
    private var cancelBag = Set<AnyCancellable>()
    private var randomNickname = ""
    private let imagePickerController = UIImagePickerController()
    
    private lazy var topHeaderView = BaseTopView()
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "프로필 수정"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    })
    
    private lazy var profileTouchableImageView = UIImageView().then({
        $0.image = UIImage(named: "profile_notUser")
        $0.contentMode = .scaleAspectFit
    })
    
    private lazy var modifyProfileButton = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.isHidden = true
    })
    
    private lazy var modifyProfileLabel = TouchableLabel().then({
        $0.text = "사진 변경"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray700.color
        $0.isHidden = true
    })
    
    private lazy var induceUserNameLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.text = "닉네임 변경"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var userNameTextField = UITextField().then {
        $0.rightView = clearButton
        $0.rightViewMode = .always
        $0.font = Font.bold(size: 32)
        $0.tintColor = DesignSystemAsset.white.color
        $0.placeholder = "닉네임을 입력해주세요."
        //        $0.delegate = self
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private lazy var clearButton = UIButton().then {
        $0.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        $0.setImage(UIImage(named: "filled_clear"), for: .normal)
    }
    
    private lazy var specializeGuideImageView = UIImageView().then({
        $0.image = UIImage(named: "common_checkmark")
        $0.tintColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var specializeGuidLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.text = "입력된 특수문자가 없어요."
        $0.textColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var countGuideImageView = UIImageView().then({
        $0.image = UIImage(named: "common_checkmark")
        $0.tintColor = DesignSystemAsset.gray700.color
    })
    
    private lazy var countGuideLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.text = "적절한 글자수의 닉네임이에요."
        $0.textColor = DesignSystemAsset.gray700.color
    })
    
    public lazy var nextButton = DefaultButton(title: "완료")
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        addViews()
        makeConstraints()
        setupIfNeeded()
        bind()
        imagePickerController.delegate = self
    }
    
    private func bind() {
        viewModel.randomNicknamePublisher()
            .sink { [weak self] response in
                guard let self = self else { return }
                self.userNameTextField.text = response
                specializeGuideImageView.image = UIImage(named: "checkmark")
                specializeGuidLabel.textColor = UIColor(red: 127/255, green: 239/255, blue: 118/255, alpha: 1)
                countGuideImageView.image = UIImage(named: "checkmark")
                countGuideLabel.textColor = UIColor(red: 127/255, green: 239/255, blue: 118/255, alpha: 1)
                
                self.nextButton.setClickable(true)
            }.store(in: &cancelBag)
        
        viewModel.setUserNamePublisher()
            .sink { [weak self] _ in
                guard let self = self else { return }
                NotificationCenter.default.post(name: NSNotification.Name("ProfileIsChanged"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }.store(in: &cancelBag)
        
        viewModel.getUserInfo()
    }
    
    public override func addViews() {
        topHeaderView.addSubviews([titleLabel])
        view.addSubviews([topHeaderView,
                          profileTouchableImageView,
                          modifyProfileButton,
                          induceUserNameLabel,
                          userNameTextField,
                          specializeGuideImageView,
                          specializeGuidLabel,
                          countGuideImageView,
                          countGuideLabel,
                          nextButton])
        modifyProfileButton.addSubview(modifyProfileLabel)
        userNameTextField.addSubview(clearButton)
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 59))
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        profileTouchableImageView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 80))
        }
        modifyProfileButton.snp.makeConstraints {
            $0.top.equalTo(profileTouchableImageView.snp.bottom).offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 32))
            $0.width.equalTo(moderateScale(number: 107))
        }
        modifyProfileLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        induceUserNameLabel.snp.makeConstraints {
            $0.top.equalTo(modifyProfileButton.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
        }
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(induceUserNameLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 40))
        }
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        specializeGuideImageView.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(moderateScale(number: 19))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 16))
        }
        specializeGuidLabel.snp.makeConstraints {
            $0.centerY.equalTo(specializeGuideImageView.snp.centerY)
            $0.leading.equalTo(specializeGuideImageView.snp.trailing).offset(moderateScale(number: 6))
        }
        countGuideImageView.snp.makeConstraints {
            $0.top.equalTo(specializeGuidLabel.snp.bottom).offset(moderateScale(number: 10))
            $0.leading.equalToSuperview().offset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 16))
        }
        countGuideLabel.snp.makeConstraints {
            $0.centerY.equalTo(countGuideImageView.snp.centerY)
            $0.leading.equalTo(countGuideImageView.snp.trailing).offset(moderateScale(number: 6))
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(topHeaderView).inset(moderateScale(number: 20))
            let offset = getSafeAreaBottom() + moderateScale(number: 12)
            $0.bottom.equalToSuperview().inset(offset)
            $0.height.equalTo(moderateScale(number: 50))
        }
    }
    
    public override func setupIfNeeded() {
        topHeaderView.backTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        modifyProfileLabel.setOpaqueTapGestureRecognizer { [weak self] in
            self?.showCameraBottomSheet(selectCameraCompletion: self?.openCamera,
                                        selectAlbumCompletion: self?.openAlbum,
                                        baseCompletion: self?.settingBaseImage)
        }
        nextButton.onTapped { [weak self] in
            guard let self = self else { return }
            self.viewModel.setNickname(userNameTextField.text!)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func clearButtonDidTap() {
        userNameTextField.text = ""
        nicknameValidate(text: userNameTextField.text ?? "")
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        nicknameValidate(text: text)
    }
    
    @objc
    private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func nicknameValidate(text: String) {
        let containsSpecialCharacters = text.range(of: "[^a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ0-9\\s]", options: .regularExpression) != nil
        let hasValidLength = (1...10).contains(text.count)
        if text.isEmpty {
            specializeGuidLabel.textColor = DesignSystemAsset.gray700.color
            countGuideLabel.textColor = DesignSystemAsset.gray700.color
            specializeGuideImageView.image = UIImage(named: "common_checkmark")
            countGuideImageView.image = UIImage(named: "common_checkmark")
        } else {
            specializeGuideImageView.image = containsSpecialCharacters ? UIImage(named: "xmark") : UIImage(named: "checkmark")
            specializeGuidLabel.textColor = containsSpecialCharacters ? DesignSystemAsset.red050.color : UIColor(red: 127/255, green: 239/255, blue: 118/255, alpha: 1)
            specializeGuidLabel.text = containsSpecialCharacters ? "특수문자가 포함되어 있어요." : "입력된 특수문자가 없어요."
            countGuideImageView.image = hasValidLength ? UIImage(named: "checkmark") : UIImage(named: "xmark")
            countGuideLabel.textColor = hasValidLength ? UIColor(red: 127/255, green: 239/255, blue: 118/255, alpha: 1) :  DesignSystemAsset.red050.color
            countGuideLabel.text = hasValidLength ? "적절한 글자수의 닉네임이에요." : "한글/영문, 숫자 포함 1~10자 이내로 설정해주세요."
        }
        if !containsSpecialCharacters && hasValidLength {
            nextButton.setClickable(true)
        } else {
            nextButton.setClickable(false)
        }
    }
    
    private func settingBaseImage() {
        profileTouchableImageView.image = UIImage(named: "profile_notUser")
    }
    
    private func openCamera() {
//#if targetEnvironment(simulator)
//        fatalError()
//#endif
        // Privacy - Camera Usage Description
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard let self = self else { return }
            guard isAuthorized else {
                showAlertGoToSetting()
                return
            }
            
            DispatchQueue.main.async {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    private func openAlbum() {
        
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard let self = self else { return }
            guard isAuthorized else {
                showAlertGoToSetting()
                return
            }
            
            DispatchQueue.main.async {
                self.imagePickerController.sourceType = .photoLibrary
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    func showAlertGoToSetting() {
        let alertController = UIAlertController(
            title: "현재 카메라 사용에 대한 접근 권한이 없습니다.",
            message: "설정 > {앱 이름}탭에서 접근을 활성화 할 수 있습니다.",
            preferredStyle: .alert
        )
        let cancelAlert = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        let goToSettingAlert = UIAlertAction(
            title: "설정으로 이동하기",
            style: .default) { _ in
                guard
                    let settingURL = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingURL)
                else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }
        [cancelAlert, goToSettingAlert]
            .forEach(alertController.addAction(_:))
        DispatchQueue.main.async {
            self.present(alertController, animated: true) // must be used from main thread only
        }
    }
}
extension ProfileEditViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let image = info[.originalImage] as? UIImage {
             
             dismiss(animated: true) {
                 self.openCropVC(image: image)
             }
         }
         dismiss(animated: true, completion: nil)
     }
}

extension ProfileEditViewController: CropViewControllerDelegate {
    public func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
        // 이미지 크롭 후 할 작업 추가
        profileTouchableImageView.image = cropped
        
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    public func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    private func openCropVC(image: UIImage) {
        
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        self.present(cropViewController, animated: true)
    }
}
