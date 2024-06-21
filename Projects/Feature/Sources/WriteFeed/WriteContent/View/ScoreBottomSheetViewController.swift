//
//  ScoreBottomSheetViewController.swift
//  Feature
//
//  Created by 김유진 on 2/26/24.
//

import Combine
import UIKit
import DesignSystem

final class ScoreBottomSheetViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    weak var delegate: OnSelectedValue?
    
    private lazy var currentScore = 0
    
    private let bottomHeight: CGFloat = moderateScale(number: 216)

    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private lazy var dimmedBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        $0.alpha = 0.0
    }
    
    private lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 24)
    }
    
    private lazy var bottomSheetTitleLabel = UILabel().then {
        $0.text = "이번 술과 안주는 어땠나요?"
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var snackDrinkStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
    }
    
    private lazy var andLabel = UILabel().then {
        $0.text = "&"
        $0.textColor = DesignSystemAsset.gray500.color
        $0.font = Font.bold(size: 20)
    }
    
    private lazy var drinkLabel = UILabel().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = DesignSystemAsset.main.color.withAlphaComponent(0.1)
        $0.textColor = DesignSystemAsset.main.color
        $0.font = Font.bold(size: 18)
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    private lazy var snackLabel = UILabel().then {
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.backgroundColor = DesignSystemAsset.main.color.withAlphaComponent(0.1)
        $0.textColor = DesignSystemAsset.main.color
        $0.font = Font.bold(size: 18)
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    private lazy var scoreLabel = UILabel().then {
        $0.text = "0점"
        $0.textColor = DesignSystemAsset.gray300.color
        $0.font = Font.bold(size: 24)
    }
    
    private lazy var scoreStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 16)
    }
    
    private lazy var clapStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = moderateScale(number: 8)
    }
    
    private lazy var clapImageView1 = UIImageView(image: UIImage(named: "writeFeed_clap"))
    private lazy var clapImageView2 = UIImageView(image: UIImage(named: "writeFeed_clap"))
    private lazy var clapImageView3 = UIImageView(image: UIImage(named: "writeFeed_clap"))
    private lazy var clapImageView4 = UIImageView(image: UIImage(named: "writeFeed_clap"))
    private lazy var clapImageView5 = UIImageView(image: UIImage(named: "writeFeed_clap"))
    
    private lazy var completeButton = DefaultButton(title: "작성 완료")
    
    init(snack: String, drink: String) {
        super.init(nibName: nil, bundle: nil)

        snackLabel.text = snack
        drinkLabel.text = drink
        
        view.layoutIfNeeded()
        
        let inset = moderateScale(number: 16)
        
        snackLabel.snp.makeConstraints { [weak self] in
            guard let selfRef = self else { return }
            
            $0.width.equalTo(selfRef.snackLabel.intrinsicContentSize.width + inset)
        }
        
        drinkLabel.snp.makeConstraints { [weak self] in
            guard let selfRef = self else { return }
            
            $0.width.equalTo(selfRef.drinkLabel.intrinsicContentSize.width + inset)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .clear
        
        setupGestureRecognizer()
        setTabEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    private func setTabEvents() {
        clapImageView1.onTapped { [weak self] in
            self?.currentScore = 1
            self?.scoreLabel.text = "1점"
            self?.scoreLabel.textColor = DesignSystemAsset.main.color
            self?.clapImageView1.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView2.image = UIImage(named: "writeFeed_clap")
            self?.clapImageView3.image = UIImage(named: "writeFeed_clap")
            self?.clapImageView4.image = UIImage(named: "writeFeed_clap")
            self?.clapImageView5.image = UIImage(named: "writeFeed_clap")
            self?.completeButton.setClickable(true)
        }
        
        clapImageView2.onTapped { [weak self] in
            self?.currentScore = 2
            self?.scoreLabel.text = "2점"
            self?.scoreLabel.textColor = DesignSystemAsset.main.color
            self?.clapImageView1.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView2.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView3.image = UIImage(named: "writeFeed_clap")
            self?.clapImageView4.image = UIImage(named: "writeFeed_clap")
            self?.clapImageView5.image = UIImage(named: "writeFeed_clap")
            self?.completeButton.setClickable(true)
        }
        
        clapImageView3.onTapped { [weak self] in
            self?.currentScore = 3
            self?.scoreLabel.text = "3점"
            self?.scoreLabel.textColor = DesignSystemAsset.main.color
            self?.clapImageView1.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView2.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView3.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView4.image = UIImage(named: "writeFeed_clap")
            self?.clapImageView5.image = UIImage(named: "writeFeed_clap")
            self?.completeButton.setClickable(true)
        }
        
        clapImageView4.onTapped { [weak self] in
            self?.currentScore = 4
            self?.scoreLabel.text = "4점"
            self?.scoreLabel.textColor = DesignSystemAsset.main.color
            self?.clapImageView1.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView2.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView3.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView4.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView5.image = UIImage(named: "writeFeed_clap")
            self?.completeButton.setClickable(true)
        }
        
        clapImageView5.onTapped { [weak self] in
            self?.currentScore = 5
            self?.scoreLabel.text = "5점"
            self?.scoreLabel.textColor = DesignSystemAsset.main.color
            self?.clapImageView1.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView2.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView3.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView4.image = UIImage(named: "writeFeed_clapFilled")
            self?.clapImageView5.image = UIImage(named: "writeFeed_clapFilled")
            self?.completeButton.setClickable(true)
        }
        
        completeButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if selfRef.currentScore != 0 {
                self?.hideBottomSheetAndGoBack()
                self?.delegate?.selectedValue(["shouldGoMain": (),
                                               "score": selfRef.currentScore])
            } else {
                self?.showToastMessageView(toastType: .error, title: "점수를 선택해주세요!")
            }
        }
    }
    
    override func addViews() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubviews([
            bottomSheetTitleLabel,
            snackDrinkStackView,
            scoreStackView,
            completeButton
        ])
        
        snackDrinkStackView.addArrangedSubviews([
            drinkLabel,
            andLabel,
            snackLabel
        ])
        
        scoreStackView.addArrangedSubviews([
            scoreLabel,
            clapStackView
        ])
        
        clapStackView.addArrangedSubviews([
            clapImageView1,
            clapImageView2,
            clapImageView3,
            clapImageView4,
            clapImageView5
        ])
    }
    
    override func makeConstraints() {
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: moderateScale(number: 10)),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: moderateScale(number: -10)),
            bottomSheetView.heightAnchor.constraint(equalToConstant: bottomHeight),
            bottomSheetViewTopConstraint
        ])
        
        bottomSheetTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(moderateScale(number: 16))
            $0.centerX.equalToSuperview()
        }
        
        snackDrinkStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(bottomSheetTitleLabel.snp.bottom).offset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 32))
        }
        
        scoreStackView.snp.makeConstraints {
            $0.top.equalTo(snackDrinkStackView.snp.bottom).offset(moderateScale(number: 14))
            $0.centerX.equalToSuperview()
        }
        
        [clapImageView1, clapImageView1, clapImageView1, clapImageView1, clapImageView1].forEach { imageView in
            imageView.snp.makeConstraints {
                $0.size.equalTo(moderateScale(number: 24))
            }
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(scoreStackView.snp.bottom).offset(moderateScale(number: 13))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 22))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 52))
        }
    }
}

// MARK: 바텀시트 노출 / 미노출
extension ScoreBottomSheetViewController {
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
extension ScoreBottomSheetViewController {
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
