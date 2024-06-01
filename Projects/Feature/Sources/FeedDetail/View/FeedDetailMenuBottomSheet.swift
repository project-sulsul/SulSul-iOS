//
//  FeedDetailMenuBottomSheet.swift
//  Feature
//
//  Created by Yujin Kim on 2024-04-20.
//

import UIKit
import DesignSystem

protocol FeedDetailMenuBottomSheetDelegate: AnyObject {
    func didTapEditFeedView()
    func didTapDeleteFeedView()
    func didTapBlockUserView()
    func didTapReportFeedView()
}

final class FeedDetailMenuBottomSheet: UIView {
    // MARK: - Properties
    //
    enum SheetType {
        case someone
        case mine
    }
    
    weak var delegate: FeedDetailMenuBottomSheetDelegate?
    
    // MARK: - Components
    //
    private lazy var dimmedView = TouchableImageView(frame: UIScreen.main.bounds).then {
        $0.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.4)
    }
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 24)
        $0.clipsToBounds = true
    }
    
    private lazy var editFeedImageView = UIImageView().then {
        $0.image = UIImage(named: "edit_feed")
    }
    
    private lazy var deleteFeedImageView = UIImageView().then {
        $0.image = UIImage(named: "delete_feed")
    }
    
    private lazy var blockUserImageView = UIImageView().then {
        $0.image = UIImage(systemName: "nosign")
        $0.tintColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var reportFeedImageView = UIImageView().then {
        $0.image = UIImage(named: "report_feed")
    }
    
    private lazy var editFeedLabel = UILabel().then {
        $0.text = "게시글 수정하기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
    }
    
    private lazy var deleteFeedLabel = UILabel().then {
        $0.text = "게시글 삭제하기"
        $0.textColor = DesignSystemAsset.red050.color
        $0.font = Font.medium(size: 16)
    }
    
    private lazy var blockUserLabel = UILabel().then {
        $0.text = "차단하기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
    }
    
    private lazy var reportFeedLabel = UILabel().then {
        $0.text = "신고하기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.animate()
    }
    
    // MARK: - Initializer
    //
    init(sheetType: SheetType) {
        super.init(frame: .zero)
        
        self.backgroundColor = DesignSystemAsset.black.color.withAlphaComponent(0.4)
        
        self.addViews(for: sheetType)
        self.makeConstraints(withType: sheetType)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method
//
extension FeedDetailMenuBottomSheet {
    private func addViews(for sheetType: SheetType) {
        let sheet = self.createSheet(for: sheetType)
        
        self.dimmedView.addSubview(sheet)
        
        self.addSubview(self.dimmedView)
    }
    
    private func makeConstraints(withType sheetType: SheetType) {
        self.containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 10))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 28))
            $0.height.equalTo(sheetType == .mine ? moderateScale(number: 68) : moderateScale(number: 116))
//            $0.height.equalTo(moderateScale(number: 68))
        }
    }
    
    private func createSheet(for sheetType: SheetType) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        switch sheetType {
        case .mine:
//            let editFeedView = createOptionView(imageView: self.editFeedImageView, label: self.editFeedLabel) { [weak self] in
//                self?.delegate?.didTapEditFeedView()
//                self?.removeFromSuperview()
//            }
            let deleteFeedView = createOptionView(imageView: self.deleteFeedImageView, label: self.deleteFeedLabel) { [weak self] in
                self?.delegate?.didTapDeleteFeedView()
                self?.removeFromSuperview()
            }
            
            stackView.addArrangedSubviews([
//                editFeedView,
                deleteFeedView
            ])
        case .someone:
            let blockUserView = createOptionView(imageView: self.blockUserImageView, label: self.blockUserLabel) { [weak self] in
                self?.delegate?.didTapBlockUserView()
                self?.removeFromSuperview()
            }
            let reportFeedView = createOptionView(imageView: self.reportFeedImageView, label: self.reportFeedLabel) { [weak self] in
                self?.delegate?.didTapReportFeedView()
                self?.removeFromSuperview()
            }
            
            stackView.addArrangedSubviews([
                blockUserView,
                reportFeedView
            ])
        }
        
        self.dimmedView.onTapped { [weak self] in
            self?.removeFromSuperview()
        }
        
        self.containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        return self.containerView
    }

    private func createOptionView(imageView: UIImageView, label: UILabel, completion: @escaping () -> Void) -> UIView {
        let optionView = UIView(frame: .zero)
        optionView.addSubviews([
            imageView,
            label
        ])
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 24))
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
        }
        
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
        
        optionView.onTapped { completion() }
        
        return optionView
    }
    
    private func animate() {
        guard let superview = self.superview else { return }
        
        self.containerView.transform = CGAffineTransform(translationX: 0, y: superview.frame.height)
        
        UIView.animate(withDuration: 0.3) {
            self.containerView.transform = .identity
        }
    }
}
