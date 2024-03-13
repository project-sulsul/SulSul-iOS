//
//  CommentViewController.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import UIKit
import Combine
import DesignSystem

public final class CommentViewController: BaseHeaderViewController {
    
    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var viewModel = CommentViewModel(feedId: 1)
    
    private lazy var commentCountView = UIView()
    
    private lazy var commentImageView = UIImageView().then {
        $0.image = UIImage(named: "comment_comment")
    }
    
    private lazy var commentCountLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.bold(size: 18)
        $0.text = "전체댓글 0"
    }
    
    private lazy var commentTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.id)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.bounces = false
    }
    
    private lazy var commentInputView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
    }
    
    private lazy var commentTextFieldView = UIView().then {
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.borderColor = DesignSystemAsset.gray300.color.cgColor
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var submitButton = UILabel().then {
        $0.textColor = DesignSystemAsset.gray500.color
        $0.font = Font.semiBold(size: 16)
        $0.text = "등록"
    }
    
    private lazy var commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력해볼까요?"
        $0.textColor = DesignSystemAsset.gray300.color
        $0.font = Font.semiBold(size: 16)
    }
    
    private lazy var inputShadowView = UIView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setHeaderText("댓글")
        
        viewModel.reloadData
            .sink { [weak self] in
                self?.commentTableView.reloadData()
            }
            .store(in: &cancelBag)
    }
    
    public override func addViews() {
        super.addViews()
        
        view.addSubviews([
            commentCountView,
            commentTableView,
            commentInputView
        ])
        
        commentCountView.addSubviews([
            commentImageView,
            commentCountLabel
        ])
        
        commentInputView.addSubview(commentTextFieldView)
        
        commentTextFieldView.addSubviews([
            commentTextField,
            submitButton
        ])
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        commentCountView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 57))
            $0.leading.trailing.centerX.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
        
        commentImageView.snp.makeConstraints {
            $0.size.equalTo(moderateScale(number: 24))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview().inset(moderateScale(number: 14))
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentImageView)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(moderateScale(number: 8))
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(commentCountView.snp.bottom)
            $0.bottom.equalTo(commentInputView.snp.top)
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        commentInputView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 90))
        }
        
        commentTextFieldView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(moderateScale(number: 12))
            $0.trailing.equalTo(submitButton.snp.leading).offset(moderateScale(number: -8))
            $0.centerY.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(moderateScale(number: 12))
            $0.centerY.equalToSuperview()
        }
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id,
                                                       for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.bind(viewModel.comments[indexPath.row])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
