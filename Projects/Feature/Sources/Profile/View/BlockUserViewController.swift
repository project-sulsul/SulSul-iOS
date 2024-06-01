//
//  BlockUserViewController.swift
//  Feature
//
//  Created by Yujin Kim on 2024-06-01.
//

import UIKit
import Combine
import DesignSystem

final class BlockUserViewController: BaseHeaderViewController {
    // MARK: Properties
    //
    var coordinator: Coordinator?
    var viewModel: BlockUserViewModel
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var tableView = UITableView().then {
        $0.register(BlockUserCell.self, forCellReuseIdentifier: BlockUserCell.reuseIdentifier)
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
        $0.rowHeight = 50
        $0.separatorStyle = .none
    }
    
    // MARK: Override methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.setTabBarHidden(true)
        self.setHeaderText("차단 관리")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.cancelBag.removeAll()
    }
    
    override func addViews() {
        super.addViews()
        
        self.view.addSubviews([self.tableView])
    }
    
    override func makeConstraints() {
        super.makeConstraints()
        
        self.tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalTo(self.headerView.snp.bottom)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: Initializer
    //
    init(viewModel: BlockUserViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom methods
//
extension BlockUserViewController {
    private func unblockUser(at indexPath: IndexPath) {
        self.showAlertView(
            withType: .twoButton,
            title: "차단을 해제할까요?",
            description: "차단을 해제하면 이 사용자의 게시물을 볼 수 있어요.",
            submitText: "해제하기",
            submitCompletion: { [weak self] in
                guard let self = self else { return }
                
                let user = self.viewModel.blockUsers[indexPath.row]
                
                self.viewModel.requestUnblockUser(user.id)
                
                self.viewModel.isUnblockedPublisher()
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] isUnblocked in
                        if isUnblocked {
                            self?.viewModel.deleteBlockUser(user)
                            self?.tableView.reloadData()
                            
                            self?.showToastMessageView(toastType: .success, title: "차단을 해제했어요.", inset: 64)
                        } else {
                            self?.showToastMessageView(toastType: .error, title: "차단해제 하는 도중 오류가 발생했어요.", inset: 64)
                        }
                    }
                    .store(in: &self.cancelBag)
            },
            cancelCompletion: nil
        )
    }
}

// MARK: - UITableView Datasource
//
extension BlockUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.blockUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BlockUserCell.reuseIdentifier, for: indexPath) as? BlockUserCell else { return .init() }
        
        let item = self.viewModel.blockUsers[indexPath.row]
        cell.bind(item, at: indexPath)
        
        return cell
    }
}

// MARK: - UITableView Delegate
//
extension BlockUserViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - BlockUserCell Delegate
//
extension BlockUserViewController: BlockUserCellDelegate {
    func didTapUnblockTouchableLabel(at indexPath: IndexPath) {
        self.unblockUser(at: indexPath)
    }
}
