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

public final class SelectSnackViewController: BaseViewController {
    
    var coordinator: AuthBaseCoordinator?
    private let viewModel: SelectSnackViewModel
    private lazy var cancelBag = Set<AnyCancellable>()
    
    private lazy var superViewInset = moderateScale(number: 20)
    
    private lazy var topHeaderView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_backArrow"), for: .normal)
        $0.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
    }
    
    private lazy var noFindSnackButton = UIButton().then {
        $0.setTitle("찾는 안주가 없어요", for: .normal)
        $0.titleLabel?.font = Font.semiBold(size: 14)
        $0.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
    }
    
    private lazy var resultEmptyView = SearchResultEmptyView().then {
        $0.addSnackButton.addTarget(self, action: #selector(didTabAddSnackButton), for: .touchUpInside)
        $0.isHidden = true
    }
    
    private lazy var searchBarView = SearchBarView(delegate: self)
    
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
    
    private lazy var snackTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.register(SnackTableViewCell.self, forCellReuseIdentifier: SnackTableViewCell.reuseIdentifier)
        $0.register(SnackSortHeaderView.self, forHeaderFooterViewReuseIdentifier: SnackSortHeaderView.id)
        $0.register(SnackFooterLineView.self, forHeaderFooterViewReuseIdentifier: SnackFooterLineView.id)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.sectionFooterHeight = 0
        $0.rowHeight = moderateScale(number: 52)
    }
    
    private lazy var nextButtonBackgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.layer.shadowColor = DesignSystemAsset.black.color.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: -40)
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 20
    }
    
    private lazy var nextButton = UIButton().then {
        $0.addTarget(self, action: #selector(didTabNextButton), for: .touchUpInside)
        $0.backgroundColor = DesignSystemAsset.gray300.color
        $0.titleLabel?.font = Font.bold(size: 16)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.setTitle("다음", for: .normal)
    }
    
    init(viewModel: SelectSnackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.setCompletedSnackDataPublisher().sink { [weak self] _ in
            self?.snackTableView.reloadData()
        }
        .store(in: &cancelBag)
        
        viewModel.searchResultCountDataPublisher().sink { [weak self] searchResultCount in
            self?.resultEmptyView.isHidden = !(searchResultCount == 0)
            self?.snackTableView.isHidden = searchResultCount == 0
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

        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        view.addSubviews([topHeaderView,
                          resultEmptyView,
                          questionNumberLabel,
                          snackTitleLabel,
                          selectedCountLabel,
                          selectLimitView,
                          searchBarView,
                          snackTableView,
                          nextButtonBackgroundView])
        
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
        
        resultEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom)
            $0.width.centerX.bottom.equalToSuperview()
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
        
        searchBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(snackTitleLabel.snp.bottom).offset(moderateScale(number: 32))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        snackTableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButtonBackgroundView.snp.top).offset(moderateScale(number: -25))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.top.equalTo(searchBarView.snp.bottom).offset(moderateScale(number: 16))
        }
        
        nextButtonBackgroundView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 89))
            $0.width.bottom.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 50))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc private func didTabAddSnackButton() {
        
    }
    
    @objc private func didTabBackButton() {
        
    }
    
    @objc private func didTabNoFindSnackButton() {
        
    }
    
    @objc private func didTabNextButton() {
        
    }
}

extension SelectSnackViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.snackSectionModelCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.snackSectionModel(in: section).cellModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SnackTableViewCell.reuseIdentifier, for: indexPath) as? SnackTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.bind(snack: viewModel.snackSectionModel(in: indexPath.section).cellModels[indexPath.row])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSnackCellModel = viewModel.snackSectionModel(in: indexPath.section).cellModels[indexPath.row]
        
        if selectedSnackCellModel.isSelect == true {
            viewModel.changeSelectedState(isSelect: false, indexPath: indexPath)
            
        } else if viewModel.selectedSnackCount() < 5 {
            viewModel.changeSelectedState(isSelect: true, indexPath: indexPath)
        }
        
        let selectedSnackCount = viewModel.selectedSnackCount()
        let yellowColor = UIColor(red: 255/255, green: 182/255, blue: 2/255, alpha: 1)

        let fullText = "\(selectedSnackCount)개 선택됨"
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "\(selectedSnackCount)개")
        attribtuedString.addAttribute(.font, value: Font.bold(size: 20), range: range)

        selectedCountLabel.attributedText = attribtuedString
        selectedCountLabel.textColor = selectedSnackCount > 0 ? yellowColor : DesignSystemAsset.gray300.color
        nextButton.backgroundColor = selectedSnackCount > 0 ? yellowColor : DesignSystemAsset.gray300.color

        snackTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SnackSortHeaderView.id) as? SnackSortHeaderView else { return nil }
        
        header.bind(viewModel.snackSectionModel(in: section).headerModel)
        
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: SnackFooterLineView.id) as? SnackFooterLineView else { return nil }

        return footer
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return moderateScale(number: 33)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return moderateScale(number: 22)
    }
}

extension SelectSnackViewController: SearchSnack {
    func searchSnackWith(_ searchText: String) {
        if searchText == "" {
            self.resultEmptyView.isHidden = true
            self.snackTableView.isHidden = false
            
            viewModel.setWithInitSnackData()
        } else {
            viewModel.setWithSearchResult(searchText)
        }

        UIView.transition(with: snackTableView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.snackTableView.reloadData() })
    }
}
