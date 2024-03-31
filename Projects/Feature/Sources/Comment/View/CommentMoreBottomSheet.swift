//
//  CommentMoreBottomSheet.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import Combine
import UIKit
import DesignSystem

final class CommentMoreBottomSheet: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var viewModel: CommentViewModel?
    var requestModel: DeleteCommentRequest?
    
    private let bottomHeight: CGFloat = moderateScale(number: 116)

    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private lazy var dimmedBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        $0.alpha = 0.0
    }
    
    private lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray050.color
        $0.layer.cornerRadius = moderateScale(number: 24)
    }
    
    lazy var editView = UIView()
    
    private lazy var editColorSelectionView = TouchColorChangeView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var editImageView = UIImageView(image: UIImage(named: "comment_edit"))
    private lazy var editLabel = UILabel().then {
        $0.text = "댓글 수정하기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
    }
    
    lazy var deleteView = UIView()
    
    private lazy var deleteColorSelectionView = TouchColorChangeView().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var deleteImageView = UIImageView(image: UIImage(named: "comment_delete"))
    private lazy var deleteLabel = UILabel().then {
        $0.text = "댓글 삭제하기"
        $0.textColor = DesignSystemAsset.red050.color
        $0.font = Font.medium(size: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .clear
        
        setupGestureRecognizer()
        
        deleteView.onTapped { [weak self] in
            guard let requestModel = self?.requestModel else { return }
            
            self?.viewModel?.didTabDeleteComment(requestModel)
            self?.hideBottomSheetAndGoBack()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    override func addViews() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubviews([
            editView,
            deleteView
        ])
        
        editView.addSubview(editColorSelectionView)
        editView.addSubview(editImageView)
        editView.addSubview(editLabel)
        
        deleteView.addSubview(deleteColorSelectionView)
        deleteView.addSubview(deleteImageView)
        deleteView.addSubview(deleteLabel)
    }
    
    override func makeConstraints() {
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: moderateScale(number: 18)),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: moderateScale(number: -18)),
            bottomSheetView.heightAnchor.constraint(equalToConstant: bottomHeight),
            bottomSheetViewTopConstraint
        ])
        
        editView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 44))
            $0.leading.trailing.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        editImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(moderateScale(number: 28))
            $0.centerY.equalToSuperview()
        }
        
        editLabel.snp.makeConstraints {
            $0.leading.equalTo(editImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
        
        deleteView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 44))
            $0.width.centerX.equalTo(editView)
            $0.top.equalTo(editView.snp.bottom).offset(moderateScale(number: 4))
        }
        
        deleteImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(moderateScale(number: 28))
            $0.centerY.equalToSuperview()
        }
        
        deleteLabel.snp.makeConstraints {
            $0.leading.equalTo(deleteImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
        
        editColorSelectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(editView)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 10))
        }
        
        deleteColorSelectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(deleteView)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 10))
        }
    }
}

// MARK: 바텀시트 노출 / 미노출
extension CommentMoreBottomSheet {
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        let bottomSheetBottomInset = moderateScale(number: 42)
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight - bottomSheetBottomInset
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

// MARK: 제스처
extension CommentMoreBottomSheet {
    private func setupGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
}
