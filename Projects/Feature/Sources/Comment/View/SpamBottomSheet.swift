//
//  SpamBottomSheet.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import Combine
import UIKit
import DesignSystem

final class SpamBottomSheet: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    var viewModel: CommentViewModel?
    
    private let bottomHeight: CGFloat = moderateScale(number: 68)

    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private lazy var dimmedBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        $0.alpha = 0.0
    }
    
    private lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 24)
    }
    
    lazy var spamView = UIView()
    private lazy var spamImageView = UIImageView(image: UIImage(named: "randomFeed_spam"))
    private lazy var spamLabel = UILabel().then {
        $0.text = "신고하기"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.medium(size: 16)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .clear
        
        setupGestureRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    override func addViews() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubviews([
            spamView
        ])
        
        spamView.addSubview(spamImageView)
        spamView.addSubview(spamLabel)
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
        
        spamView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 44))
            $0.leading.trailing.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(moderateScale(number: 12))
        }
        
        spamImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(moderateScale(number: 18))
            $0.centerY.equalToSuperview()
        }
        
        spamLabel.snp.makeConstraints {
            $0.leading.equalTo(spamImageView.snp.trailing).offset(moderateScale(number: 8))
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: 바텀시트 노출 / 미노출
extension SpamBottomSheet {
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
extension SpamBottomSheet {
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
