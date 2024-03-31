//
//  DetailFeedCommentCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import Combine
import UIKit
import DesignSystem
import Service

final class DetailFeedCommentCell: UICollectionViewCell {
    static let reuseIdentifier: String = "DetailFeedCommentCell"
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var parentID = 0
    
    private lazy var viewModel = CommentViewModel(feedId: 1)
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        addViews()
        makeConstraints()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.addSubview(tableView)
    }
    
    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.reloadData
            .sink { [weak self] in
                guard let self = self else { return }
                
                self.tableView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

extension DetailFeedCommentCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return min(viewModel.comments.count, 5)
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id, for: indexPath) as? CommentCell 
        else { return UITableViewCell() }
        
        let comment = viewModel.comments[indexPath.row]
        
        cell.selectionStyle = .none
        cell.bind(comment)
        
        cell.replayLabel.onTapped { [weak self] in
            guard let self = self else { return }
            self.parentID = comment.comment_id
        }
        
        cell.moreButton.onTapped { [weak self] in
            let userId = UserDefaultsUtil.shared.getInstallationId()
            if userId == comment.user_info.user_id {
                let vc = CommentMoreBottomSheet()
                vc.viewModel = self?.viewModel
                vc.requestModel = .init(feed_id: 1, comment_id: comment.comment_id)
                vc.modalPresentationStyle = .overFullScreen
//                self?.present(vc, animated: false)
                
            } else {
                let vc = SpamBottomSheet()
                vc.viewModel = self?.viewModel
                vc.modalPresentationStyle = .overFullScreen
//                self?.present(vc, animated: false)
            }
        }
        
        return cell
    }
}

extension DetailFeedCommentCell: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
}
