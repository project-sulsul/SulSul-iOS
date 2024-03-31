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

public final class ProfileEditViewController: DisappearKeyBoardBaseViewController {
    
    var coordinator: MoreBaseCoordinator?
    private let viewModel = ProfileEditViewModel()
    
    private var cancelBag = Set<AnyCancellable>()
    private var randomNickname = ""
    
    private lazy var topHeaderView = BaseTopView()
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "프로필 수정"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
    })
    
    private lazy var profileTouchableImageView = TouchableImageView(frame: .zero).then({
        $0.image = UIImage(systemName: "circle.fill")
    })
    
    private lazy var modifyProfileButton = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray200.color
        $0.layer.cornerRadius = moderateScale(number: 16)
    })
    
    private lazy var modifyProfileLabel = TouchableLabel().then({
        $0.text = "사진 변경"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray700.color
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
    
    private lazy var resetTouchableLabel = TouchableLabel().then({
        $0.text = "랜덤 닉네임 쓸래요!"
        $0.font = Font.bold(size: 16)
        $0.textColor = DesignSystemAsset.gray400.color
    })
    
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
    
    public lazy var nextButton = IndicatorTouchableView().then {
        $0.text = "다음"
        $0.textColor = DesignSystemAsset.gray300.color
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    public override func viewDidLoad() {
        self.tabBarController?.setTabBarHidden(true)
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        addViews()
        makeConstraints()
        setupIfNeeded()
        bind()
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
                
                self.nextButton.textColor = DesignSystemAsset.gray200.color
                self.nextButton.backgroundColor = DesignSystemAsset.main.color
                self.nextButton.isUserInteractionEnabled = true
            }.store(in: &cancelBag)
        
        viewModel.setUserNamePublisher()
            .sink { [weak self] _ in
                guard let self = self else { return }
                NotificationCenter.default.post(name: NSNotification.Name("ProfileIsChanged"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }.store(in: &cancelBag)
    }
    
    public override func addViews() {
        topHeaderView.addSubviews([titleLabel])
        view.addSubviews([topHeaderView,
                          profileTouchableImageView,
                          modifyProfileButton,
                          induceUserNameLabel,
                          userNameTextField,
                          resetTouchableLabel,
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
        resetTouchableLabel.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-24)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(topHeaderView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(moderateScale(number: 50))
        }
    }
    
    public override func setupIfNeeded() {
        topHeaderView.backTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        modifyProfileLabel.setOpaqueTapGestureRecognizer { [weak self] in
            self?.showCameraBottomSheet(selectCameraCompletion: self?.openCamera,
                                        selectAlbumCompletion: nil,
                                        baseCompletion: nil)
        }
        resetTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            self.viewModel.getRandomNickname()
        }
        nextButton.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            // TODO: - validation 검증로직 추가 통과 안되면 nextButton 비활성화
            self.viewModel.setNickname(userNameTextField.text!)
        }
    }
    
    @objc private func clearButtonDidTap() {
        userNameTextField.text = ""
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        let containsSpecialCharacters = text.range(of: "[^a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ0-9\\s]", options: .regularExpression) != nil
        let hasValidLength = (1...10).contains(text.count)
        
        specializeGuideImageView.image = containsSpecialCharacters ? UIImage(named: "common_checkmark") : UIImage(named: "checkmark")
        specializeGuidLabel.textColor = containsSpecialCharacters ? DesignSystemAsset.gray700.color : UIColor(red: 127/255, green: 239/255, blue: 118/255, alpha: 1)
        countGuideImageView.image = hasValidLength ? UIImage(named: "checkmark") : UIImage(named: "common_checkmark")
        countGuideLabel.textColor = hasValidLength ? UIColor(red: 127/255, green: 239/255, blue: 118/255, alpha: 1) :  DesignSystemAsset.gray700.color
        
        if !containsSpecialCharacters && hasValidLength {
            nextButton.textColor = DesignSystemAsset.gray200.color
            nextButton.backgroundColor = DesignSystemAsset.main.color
            nextButton.isUserInteractionEnabled = true
        } else {
            nextButton.textColor = DesignSystemAsset.gray300.color
            nextButton.backgroundColor = DesignSystemAsset.gray100.color
            nextButton.isUserInteractionEnabled = false
        }
        
    }
    
    private func openCamera() {
#if targetEnvironment(simulator)
        fatalError()
#endif
        // Privacy - Camera Usage Description
        AVCaptureDevice.requestAccess(for: .video) { [weak self] isAuthorized in
            guard isAuthorized else {
                self?.showAlertGoToSetting()
                return
            }
            
            DispatchQueue.main.async {
                let pickerController = UIImagePickerController()
                pickerController.sourceType = .camera
                pickerController.allowsEditing = false
                pickerController.mediaTypes = ["public.image"]
                pickerController.delegate = self
                self?.present(pickerController, animated: true)
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
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        self.profileTouchableImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}
