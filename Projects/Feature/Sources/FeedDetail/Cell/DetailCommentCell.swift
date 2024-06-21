//
//  DetailCommentCell.swift
//  Feature
//
//  Created by Yujin Kim on 2024-03-14.
//

import Combine
import UIKit
import DesignSystem
import Service

final class DetailCommentCell: UICollectionViewCell {
    // MARK: - Properties
    //
    static let reuseIdentifier = "FeedDetailCommentCell"
    
    private let numberOfSection = 1
    
    private var numberOfItems = 0
    private var parentID = 0
    private var viewModel: DetailCommentViewModel?
    private var cancelBag = Set<AnyCancellable>()
    
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
    
    private lazy var commentTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    // MARK: - Initializer
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        self.addViews()
        self.makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom method
//
extension DetailCommentCell {
    private func addViews() {
        self.addSubview(self.commentTableView)
    }
    
    private func makeConstraints() {
        self.commentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func bind(withID feedID: Int) {
        self.viewModel = DetailCommentViewModel(feedID: feedID)
        self.parentID = feedID
        
        self.viewModel?.reloadData
            .sink { [weak self] in
                guard let self = self else { return }
                
                if let comments = viewModel?.commentsWithoutChildrens {
                    self.numberOfItems = comments.count
                }
                
                self.commentTableView.reloadData()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - UITableView DataSource
//
extension DetailCommentCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.numberOfSection
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if numberOfItems > 5 {
            return min(numberOfItems, 5)
        }
        return numberOfItems
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id, for: indexPath) as? CommentCell
        else { return .init() }
        
        if let comment = viewModel?.commentsWithoutChildrens[indexPath.row] {
            cell.selectionStyle = .none
            cell.bind(comment)
            
            cell.replayLabel.isHidden = true
            
            cell.moreButton.onTapped { [weak self] in
                guard let self = self else { return }
                
                let userID = UserDefaultsUtil.shared.getInstallationId()
                let viewController: UIViewController
                
                if userID == comment.user_info.user_id {
                    let commentMoreBottomSheet = CommentMoreBottomSheet()
                    commentMoreBottomSheet.viewModel = CommentViewModel(feedId: self.parentID)
                    viewController = commentMoreBottomSheet
                } else {
                    let spamBottomSheet = SpamBottomSheet()
                    spamBottomSheet.viewModel = CommentViewModel(feedId: self.parentID)
                    viewController = spamBottomSheet
                }
                
                self.parentViewController?.present(viewController, animated: true, completion: nil)
            }
        }
        
        return cell
    }
}

// MARK: - UITableView Delegate
//
extension DetailCommentCell: UITableViewDelegate {
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
