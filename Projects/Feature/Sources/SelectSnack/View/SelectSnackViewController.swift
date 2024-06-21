//
//  SelectSnackViewController.swift
//  Feature
//
//  Created by 김유진 on 2023/12/03.
//

import Combine
import DesignSystem
import UIKit

protocol SearchSnack: AnyObject {
    func searchSnackWith(_ searchText: String)
}

public final class SelectSnackViewController: HiddenTabBarBaseViewController {
    
    var coordinator: Coordinator?
    private lazy var cancelBag = Set<AnyCancellable>()
    private let viewModel: SelectSnackViewModel
    private let selectTasteCase: SelectTasteCase
    
    private lazy var superViewInset = moderateScale(number: 20)
    
    private lazy var topHeaderView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_leftArrow"), for: .normal)
        $0.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
    }
    
    private lazy var noFindSnackButton = UIButton().then {
        $0.setTitle("찾는 안주가 없어요", for: .normal)
        $0.titleLabel?.font = Font.semiBold(size: 14)
        $0.setTitleColor(DesignSystemAsset.main.color, for: .normal)
    }
        
    private lazy var questionNumberLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.text = "Q2."
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var snackTitleLabel = UILabel().then {
        $0.font = Font.bold(size: 32)
        $0.text = "함께 먹는 안주"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private lazy var selectLimitView = SelectLimitToolTipView()
    
    private lazy var selectedCountLabel = UILabel().then {
        $0.font = Font.medium(size: 14)
        $0.textColor = DesignSystemAsset.gray300.color
        $0.text = "0개 선택됨"
        
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "0개")
        attribtuedString.addAttribute(.font, value: Font.bold(size: 20), range: range)
        $0.attributedText = attribtuedString
    }
    
    private var selectSnackView: SelectSnackView!
    
    private lazy var nextButtonBackgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.layer.shadowColor = DesignSystemAsset.black.color.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: -40)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 20
    }
    
    private lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(didTabNextButton), for: .touchUpInside)
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.setTitleColor(DesignSystemAsset.gray300.color, for: .normal)
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.setTitle("다음", for: .normal)
    }
    
    init(viewModel: SelectSnackViewModel, selectTasteCase: SelectTasteCase) {
        self.viewModel = viewModel
        self.selectTasteCase = selectTasteCase
        super.init(nibName: nil, bundle: nil)
        
        selectSnackView = SelectSnackView(delegate: self,
                                          viewModel: viewModel)
        
        selectSnackView.didTabSnack = self
        
        viewModel.setCompletedSnackDataPublisher().sink { [weak self] _ in
            self?.selectSnackView.snackTableView.reloadData()
        }
        .store(in: &cancelBag)
        
        viewModel.searchResultCountDataPublisher().sink { [weak self] searchResultCount in
            self?.selectSnackView.resultEmptyView.isHidden = !(searchResultCount == 0)
            self?.selectSnackView.snackTableView.isHidden = searchResultCount == 0
        }
        .store(in: &cancelBag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = DesignSystemAsset.black.color
        overrideUserInterfaceStyle = .dark
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        addViews()
        makeConstraints()
        bind()
        
        switch selectTasteCase {
        case .next:
            nextButton.setTitle("다음", for: .normal)
        case .store, .bottomSheet:
            nextButton.setTitle("저장", for: .normal)
        }
        
        noFindSnackButton.onTapped { [weak self] in
            let vc = AddSnackViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        selectSnackView.resultEmptyView.addSnackButton.onTapped { [weak self] in
            let vc = AddSnackViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          questionNumberLabel,
                          snackTitleLabel,
                          selectedCountLabel,
                          selectLimitView,
                          selectSnackView,
                          nextButtonBackgroundView,
                          selectSnackView])
        
        topHeaderView.addSubview(backButton)
        topHeaderView.addSubview(noFindSnackButton)
        nextButtonBackgroundView.addSubview(nextButton)
    }
    
    public override func makeConstraints() {
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        
        noFindSnackButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(superViewInset)
        }
        
        questionNumberLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(topHeaderView.snp.bottom)
        }
        
        snackTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(questionNumberLabel.snp.bottom)
        }
        
        selectedCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(topHeaderView.snp.bottom).offset(moderateScale(number: 36))
        }
        
        selectLimitView.snp.makeConstraints {
            $0.bottom.equalTo(selectedCountLabel.snp.top)
            $0.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 26))
            $0.width.equalTo(moderateScale(number: 108))
        }
        
        selectSnackView.snp.makeConstraints {
            $0.top.equalTo(snackTitleLabel.snp.bottom).offset(moderateScale(number: 32))
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(moderateScale(number: -9))
        }
        
        nextButtonBackgroundView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 89))
            $0.width.bottom.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(moderateScale(number: 42))
            $0.height.equalTo(moderateScale(number: 50))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.completeSnackPreferencePublisher()
            .sink { [weak self] in
                guard let self = self else { return }
                if let authCoordinator = self.coordinator as? AuthCoordinator {
                    authCoordinator.moveTo(appFlow: TabBarFlow.auth(.profileInput(.selectComplete)), userData: ["userName": viewModel.getUserNickName()])
                } else if let moreCoordinator = self.coordinator as? MoreCoordinator {
                    self.navigationController?.popViewController(animated: true)
                }
            }.store(in: &cancelBag)
    }
    
    @objc private func didTabBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTabNoFindSnackButton() {
        
    }
    
    @objc private func didTabNextButton() {
        self.viewModel.sendSetUserSnackPreference()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SelectSnackViewController: SearchSnack {
    func searchSnackWith(_ searchText: String) {
        if searchText == "" {
            self.selectSnackView.resultEmptyView.isHidden = true
            self.selectSnackView.snackTableView.isHidden = false
            
            viewModel.setWithInitSnackData()
        } else {
            viewModel.setWithSearchResult(searchText)
        }

        UIView.transition(with: selectSnackView.snackTableView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.selectSnackView.snackTableView.reloadData() })
    }
}

extension SelectSnackViewController: OnSelectedValue {
    func selectedValue(_ value: [String : Any]) {
        if let _ = value["shouldSetCount"] as? Void {
            let selectedSnackCount = viewModel.selectedSnackCount()
            
            let fullText = "\(selectedSnackCount)개 선택됨"
            let attribtuedString = NSMutableAttributedString(string: fullText)
            let range = (fullText as NSString).range(of: "\(selectedSnackCount)개")
            attribtuedString.addAttribute(.font, value: Font.bold(size: 20), range: range)
            
            selectedCountLabel.attributedText = attribtuedString
            selectedCountLabel.textColor = selectedSnackCount > 0 ? DesignSystemAsset.main.color : DesignSystemAsset.gray300.color
            nextButton.backgroundColor = selectedSnackCount > 0 ? DesignSystemAsset.main.color : DesignSystemAsset.gray100.color
            nextButton.setTitleColor(selectedSnackCount > 0 ? DesignSystemAsset.gray050.color : DesignSystemAsset.gray300.color, for: .normal)
            
        } else if let _ = value["shouldShowErrorAlert"] {
            self.showAlertView(withType: .oneButton,
                                title: "선택 불가",
                                description: "5개 이상 선택할 수 없어요.",
                                isSubmitColorYellow: true,
                                submitCompletion: nil,
                                cancelCompletion: nil)
        }
    }
}
