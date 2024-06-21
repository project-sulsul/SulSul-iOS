//
//  CameraBottomSheet.swift
//  DesignSystem
//
//  Created by 이범준 on 2024/01/18.
//

import UIKit
import SnapKit
import Then

final class CameraBottomSheet: UIView {
    private lazy var backgroundView = TouchableView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    private lazy var containerView = UIView().then({
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 16)
        $0.clipsToBounds = true
    })
    
    private lazy var selectCameraView = TouchableView()
    
    private lazy var selectAlbumView = TouchableView()
    
    private lazy var selectBaseView = TouchableView()
    
    private lazy var cameraImageView = UIImageView().then({
        $0.image = UIImage(named: "camera")
    })
    
    private lazy var cameraLabel = UILabel().then({
        $0.text = "사진 촬영"
    })
    
    private lazy var albumImageView = UIImageView().then({
        $0.image = UIImage(named: "album")
    })
    
    private lazy var albumLabel = UILabel().then({
        $0.text = "앨범에서 사진 선택"
    })
    
    private lazy var baseImageView = UIImageView().then({
        $0.image = UIImage(named: "baseprofile")
    })
    
    private lazy var baseLabel = UILabel().then({
        $0.text = "기본 이미지 사용"
    })
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        addViews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(selectCameraCompletion: (() -> Void)?,
              selectAlbumCompletion: (() -> Void)?,
              selectBaseCompletion: (() -> Void)?) {
        backgroundView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.removeFromSuperview()
        }
        selectCameraView.setOpaqueTapGestureRecognizer { [weak self] in
            selectCameraCompletion?()
            self?.removeFromSuperview()
        }
        selectAlbumView.setOpaqueTapGestureRecognizer { [weak self] in
            selectAlbumCompletion?()
            self?.removeFromSuperview()
        }
        selectBaseView.setOpaqueTapGestureRecognizer { [weak self] in
            selectBaseCompletion?()
            self?.removeFromSuperview()
        }
    }
    
    private func addViews() {
        addSubviews([backgroundView,
                     containerView])
        containerView.addSubviews([selectCameraView,
                                   selectAlbumView,
                                   selectBaseView])
        selectCameraView.addSubviews([cameraImageView,
                                      cameraLabel])
        selectAlbumView.addSubviews([albumImageView,
                                     albumLabel])
        selectBaseView.addSubviews([baseImageView,
                                    baseLabel])
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 164))
            $0.leading.trailing.bottom.equalToSuperview()
        }
        selectCameraView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 12))
            $0.width.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 44))
        }
        selectAlbumView.snp.makeConstraints {
            $0.top.equalTo(selectCameraView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 44))
        }
        selectBaseView.snp.makeConstraints {
            $0.top.equalTo(selectAlbumView.snp.bottom)
            $0.width.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 44))
        }
        cameraImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 24))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        cameraLabel.snp.makeConstraints {
            $0.leading.equalTo(cameraImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
        albumImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 24))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        albumLabel.snp.makeConstraints {
            $0.leading.equalTo(albumImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
        baseImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(moderateScale(number: 24))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        baseLabel.snp.makeConstraints {
            $0.leading.equalTo(baseImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
    }
}
