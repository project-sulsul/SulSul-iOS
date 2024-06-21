//
//  CommentViewController.swift
//  Feature
//
//  Created by 김유진 on 3/13/24.
//

import UIKit
import Combine
import Service
import DesignSystem

public final class CommentViewController: BaseHeaderViewController {
    var feedID: Int
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var viewModel: CommentViewModel
    
    private lazy var commentCountView = UIView()
    
    private lazy var commentImageView = UIImageView().then {
        $0.image = UIImage(named: "comment_comment")
    }
    
    private lazy var parentId = 0
    
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
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var commentInputView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.black.color
    }
    
    private lazy var commentTextFieldView = UIView().then {
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.borderColor = DesignSystemAsset.gray900.color.cgColor
        $0.layer.cornerRadius = moderateScale(number: 8)
    }
    
    private lazy var submitButton = UILabel().then {
        $0.textColor = DesignSystemAsset.gray500.color
        $0.font = Font.semiBold(size: 16)
        $0.text = "등록"
    }
    
    private lazy var commentTextField = UITextField().then {
        $0.placeholder = "댓글을 입력해볼까요?"
        $0.textColor = DesignSystemAsset.gray900.color
        $0.font = Font.semiBold(size: 16)
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private lazy var inputShadowView = UIView()
    
    public init(feedID: Int = 0) {
        self.feedID = feedID
        self.viewModel = CommentViewModel(feedId: feedID)
        
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextField.becomeFirstResponder()
        
        setHeaderText("댓글")
        
        bind()
        setTabEvents()
    }
    
    private func bind() {
        viewModel.reloadData
            .sink { [weak self] in
                guard let selfRef = self else { return }
                
                let allCount = selfRef.viewModel.comments.count
                self?.commentCountLabel.text = "전체댓글 \(allCount)"
                self?.commentTableView.reloadData()
            }
            .store(in: &cancelBag)
        
        changedKeyboardHeight
            .sink { [weak self] height in
                let newHeight: CGFloat = (height == 0) ? 90 : height + moderateScale(number: 70)
                
                self?.commentInputView.snp.remakeConstraints {
                    $0.leading.trailing.bottom.equalToSuperview()
                    $0.height.equalTo(moderateScale(number: newHeight))
                }
            }
            .store(in: &cancelBag)
    }
    
    private func setTabEvents() {
        submitButton.onTapped { [weak self] in
            guard let selfRef = self else { return }
            
            if let text = self?.commentTextField.text,
               text.removeSpace() != "" {
                self?.commentTextFieldView.layer.borderColor = DesignSystemAsset.gray900.color.cgColor
                self?.submitButton.textColor = DesignSystemAsset.gray500.color
                self?.commentTextField.text = ""
                self?.viewModel.didTabWriteComment(selfRef.feedID,
                                                   content: text,
                                                   parentId: selfRef.parentId)
                self?.parentId = 0
            }
        }
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
            $0.bottom.equalToSuperview().inset(moderateScale(number: 90))
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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.id,
                                                       for: indexPath) as? CommentCell else { return UITableViewCell() }
        
        let comment = viewModel.comments[indexPath.row]
        
        cell.selectionStyle = .none
        cell.bind(comment)
        
        cell.replayLabel.onTapped { [weak self] in
            self?.parentId = comment.comment_id
            self?.commentTextField.becomeFirstResponder()
        }
        
        cell.moreButton.onTapped { [weak self] in
            let userId = UserDefaultsUtil.shared.getInstallationId()
            if userId == comment.user_info.user_id {
                let vc = CommentMoreBottomSheet()
                vc.viewModel = self?.viewModel
                vc.requestModel = .init(feed_id: 1, comment_id: comment.comment_id)
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
                
            } else {
                let vc = SpamBottomSheet()
                vc.viewModel = self?.viewModel
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CommentViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.removeSpace() != "" {
            commentTextFieldView.layer.borderColor = DesignSystemAsset.gray300.color.cgColor
            submitButton.textColor = DesignSystemAsset.main.color
            
        } else {
            commentTextFieldView.layer.borderColor = DesignSystemAsset.gray900.color.cgColor
            submitButton.textColor = DesignSystemAsset.gray500.color
        }
    }
}
