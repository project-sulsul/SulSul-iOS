//
//  SearchViewController.swift
//  Feature
//
//  Created by 김유진 on 2024/01/10.
//

import UIKit
import Combine
import DesignSystem
import Service

public final class SearchViewController: BaseHeaderViewController, CommonBaseCoordinated {
    var coordinator: CommonBaseCoordinator?
    
    private var cancelBag = Set<AnyCancellable>()
    private lazy var viewModel = SearchViewModel()
    
    private lazy var searchTextField = UITextField().then {
        $0.placeholder = "검색어를 입력해주세요"
        $0.font = Font.bold(size: 32)
        $0.delegate = self
    }
    
    private lazy var searchResetButton = UIButton().then {
        $0.setImage(UIImage(named: "search_reset"), for: .normal)
        $0.addTarget(self, action: #selector(didTabsearchResetButton), for: .touchUpInside)
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
    }
    
    private lazy var recentKeywordTitleLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray700.color
        $0.text = "최근 검색어"
    }
    
    private lazy var recentKeywordResetButton = UIButton().then {
        $0.setTitle("모두 삭제", for: .normal)
        $0.titleLabel?.font = Font.semiBold(size: 14)
        $0.titleLabel?.textColor = DesignSystemAsset.gray700.color
    }
    
    private lazy var recentKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout()).then {
        $0.register(RecentKeywordCell.self, forCellWithReuseIdentifier: RecentKeywordCell.id)
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var resultTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.register(SearchFeedCell.self, forCellReuseIdentifier: SearchFeedCell.id)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.sectionFooterHeight = 0
        $0.isHidden = true
        
    }
    
    private lazy var emptyLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray600.color
        $0.font = Font.semiBold(size: 15)
        $0.isHidden = true
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private lazy var feedCountLabel = UILabel().then {
        $0.font = Font.bold(size: 18)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        titleLabel.text = "검색"

        bind()
        setTabEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchTextField.becomeFirstResponder()
    }
    
    private func bind() {
        setVisibilityKeywordLabel()
        
        viewModel.reloadRecentKeywordData
            .sink { [weak self] in
                guard let self else { return }
                
                self.setVisibilityKeywordLabel()
                self.recentKeywordCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        viewModel.reloadSearchResults
            .sink { [weak self] isEmpty in
                guard let selfRef = self else { return }
                
                self?.recentKeywordTitleLabel.isHidden = true
                self?.recentKeywordResetButton.isHidden = true
                
                self?.resultTableView.isHidden = false
                self?.resultTableView.reloadData()
                
                if !isEmpty {
                    self?.feedCountLabel.isHidden = false
                    self?.feedCountLabel.text = "피드 \(selfRef.viewModel.feedSearchResults.count)"
                    self?.feedCountLabel.asColor(targetString: "\(selfRef.viewModel.feedSearchResults.count)",
                                                 color: DesignSystemAsset.main.color)
                }
                
                self?.emptyLabel.isHidden = !isEmpty
                
                if isEmpty {
                    self?.emptyLabel.text = "\"\(self?.searchTextField.text ?? "")\"의 \n검색결과가 없어요"
                    self?.emptyLabel.asColor(targetString: "\"\(self?.searchTextField.text ?? "")\"",
                                             color: DesignSystemAsset.main.color)
                }
            }
            .store(in: &cancelBag)
        
        viewModel.error
            .sink { [weak self] in
                self?.showToastMessageView(toastType: .error, title: "잠시 후 다시 시도해주세요.")
            }
            .store(in: &cancelBag)
    }
    
    private func setTabEvents() {
        recentKeywordResetButton.onTapped { [weak self] in
            UserDefaultsUtil.shared.remove(.recentKeyword)
            self?.recentKeywordCollectionView.reloadData()
            self?.setVisibilityKeywordLabel()
        }
    }
    
    private func setVisibilityKeywordLabel() {
        let isKeywordEmpty = viewModel.keywordCount() == 0
        recentKeywordTitleLabel.isHidden = isKeywordEmpty
        recentKeywordResetButton.isHidden = isKeywordEmpty
    }
    
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension: .absolute(40))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: layoutSize.heightDimension ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        group.interItemSpacing = .fixed(moderateScale(number: 16))

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = moderateScale(number: 16)

        return .init(section: section)
    }
    
    public override func addViews() {
        super.addViews()
        
        view.addSubviews([
            searchTextField,
            searchResetButton,
            lineView,
            recentKeywordTitleLabel,
            recentKeywordResetButton,
            recentKeywordCollectionView,
            resultTableView,
            emptyLabel,
            feedCountLabel
        ])
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(moderateScale(number: 28))
            $0.leading.equalTo(headerView).offset(moderateScale(number: 20))
            $0.trailing.equalTo(searchResetButton.snp.leading).offset(moderateScale(number: -8))
            $0.height.equalTo(moderateScale(number: 40))
        }
        
        searchResetButton.snp.makeConstraints {
            $0.centerY.equalTo(searchTextField)
            $0.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.size.equalTo(moderateScale(number: 32))
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(moderateScale(number: 12))
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 2))
        }
        
        recentKeywordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(moderateScale(number: 21))
            $0.leading.equalTo(headerView).offset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 28))
        }
        
        recentKeywordResetButton.snp.makeConstraints {
            $0.trailing.equalTo(searchResetButton)
            $0.centerY.equalTo(recentKeywordTitleLabel)
        }
        
        recentKeywordCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentKeywordTitleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalTo(headerView).offset(moderateScale(number: 20))
            $0.trailing.equalTo(searchResetButton)
            $0.bottom.equalToSuperview()
        }
        
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(feedCountLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(moderateScale(number: 385))
        }
        
        feedCountLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text else { return true }
        
        let textIsNotEmpty = !(searchText.trimmingCharacters(in: .whitespaces).isEmpty)
        let savedKeywordList = UserDefaultsUtil.shared.recentKeywordList() ?? []
        
        if textIsNotEmpty, savedKeywordList.count <= 5, !(savedKeywordList.contains(searchText)) {
            let newKeywordList = (UserDefaultsUtil.shared.recentKeywordList() ?? []) + [searchText]
            UserDefaultsUtil.shared.setRecentKeywordList(newKeywordList)
        }
        
        recentKeywordCollectionView.reloadData()
        recentKeywordCollectionView.isHidden = true
        recentKeywordTitleLabel.isHidden = true
        recentKeywordResetButton.isHidden = true
        
        viewModel.search(text: searchText)
        
        return true
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchKeywords().count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentKeywordCell.id,
                                                            for: indexPath) as? RecentKeywordCell else { return UICollectionViewCell() }
        
        cell.bind(viewModel.searchKeyword(indexPath.row))
        
        cell.onTapped { [weak self] in
            self?.searchTextField.text = self?.viewModel.searchKeyword(indexPath.row)
            self?.viewModel.search(text: self?.searchTextField.text)
        }
        
        cell.deleteButton.onTapped {
            self.viewModel.removeSelectedKeyword(indexPath)
        }
                
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension SearchViewController {
    @objc private func didTabsearchResetButton() {
        searchTextField.text = ""
        
        emptyLabel.isHidden = true
        feedCountLabel.isHidden = true
        resultTableView.isHidden = true
        
        recentKeywordTitleLabel.isHidden = false
        recentKeywordResetButton.isHidden = false
        recentKeywordCollectionView.isHidden = false
        
        setVisibilityKeywordLabel()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feedSearchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchFeedCell.id,
                                                       for: indexPath) as? SearchFeedCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.bind(viewModel.feedSearchResults[indexPath.row])
        
        cell.onTapped { [weak self] in
            if let feedId = self?.viewModel.feedSearchResults[indexPath.row].feed_id {
                self?.coordinator?.moveTo(appFlow: TabBarFlow.common(.detailFeed),
                                          userData: ["feedId": feedId])
            }
        }
                
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return moderateScale(number: 102)
    }
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
