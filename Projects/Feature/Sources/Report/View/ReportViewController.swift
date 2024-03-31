//
//  ReportViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import UIKit
import SnapKit
import DesignSystem

public final class ReportViewController: BaseViewController {
    
    var coordinator: CommonBaseCoordinator?
    private let viewModel: ReportViewModel = ReportViewModel()
    
    private var buttonBottomConstraint: Constraint?
    private let textViewPlaceHolder = "텍스트를 입력하세요"
    private let maxTextCount: Int = 100
    
    private lazy var superViewInset = moderateScale(number: 20)
    
    private lazy var topHeaderView = UIView()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "common_backArrow"), for: .normal)
        $0.addTarget(self, action: #selector(didTabBackButton), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.bold(size: 32)
        $0.text = "신고하기"
        $0.textColor = DesignSystemAsset.white.color
    }
    
    private let subTitleLabel = UILabel().then({
        $0.font = Font.medium(size: 18)
        $0.text = "신고 사유가 무엇일까요?"
        $0.textColor = DesignSystemAsset.white.color
    })
    
    private lazy var reportTableView = UITableView(frame: .zero, style: .plain).then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.register(ReportTableViewCell.self, forCellReuseIdentifier: ReportTableViewCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.sectionFooterHeight = 0
        $0.rowHeight = moderateScale(number: 52)
    }
    
    private lazy var etcReportTextView = UITextView().then({
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = moderateScale(number: 8)
        $0.layer.borderWidth = moderateScale(number: 1)
        $0.layer.borderColor = DesignSystemAsset.gray400.color.cgColor
        $0.textContainerInset = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
        $0.font = Font.semiBold(size: 16)
        $0.text = textViewPlaceHolder
        $0.textColor = DesignSystemAsset.gray900.color
        $0.isHidden = true
        $0.delegate = self
    })
    
    // MARK: - 임시로 넣어둔거 나중에 기획 변경되면 수정
    private lazy var textCountLabel = UILabel().then({
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
        $0.isHidden = true
        $0.text = "0/\(maxTextCount)"
    })

    private lazy var etcReportLabel = UILabel().then({
        $0.font = Font.regular(size: 14)
        $0.text = "- 신고 내용은 자세히 적을수록 좋아요!\n- 허위사실이나 악의적인 목적으로 작성된 내용은 처리되지 않을 수 있습니다."
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = DesignSystemAsset.gray400.color
        $0.isHidden = true
        $0.numberOfLines = 0
    })
    
    public lazy var submitTouchableLabel = IndicatorTouchableView().then {
        $0.text = "다음"
        $0.textColor = DesignSystemAsset.gray200.color
        $0.font = Font.bold(size: 16)
        $0.backgroundColor = DesignSystemAsset.main.color
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
//        $0.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        self.tabBarController?.setTabBarHidden(true)
        addViews()
        makeConstraints()
    }
    
    public override func addViews() {
        super.addViews()
        view.addSubviews([topHeaderView,
                          titleLabel,
                          subTitleLabel,
                          reportTableView,
                          etcReportTextView,
                          etcReportLabel,
                          textCountLabel,
                          submitTouchableLabel])
        topHeaderView.addSubview(backButton)
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
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
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        reportTableView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 272))
        }
        etcReportTextView.snp.makeConstraints {
            $0.top.equalTo(reportTableView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 120))
        }
        textCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(etcReportTextView.snp.bottom)
            $0.trailing.equalTo(etcReportTextView.snp.trailing)
        }
        etcReportLabel.snp.makeConstraints {
            $0.top.equalTo(etcReportTextView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 66))
        }
        submitTouchableLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
            
            let offset = getSafeAreaBottom() + moderateScale(number: 12)
            buttonBottomConstraint = $0.bottom.equalToSuperview().inset(offset).constraint
        }
    }
    
    public override func setupIfNeeded() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        submitTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
    
            self?.showToastMessageView(toastType: .error, title: "ㅎ이ㅏ멀;ㅐ야러ㅔㅁㄷ")
        }
    }
    
    @objc private func didTabBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    public override func deinitialize() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: NSNotification) {
        view.frame.origin.y -= 300
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }

    private func updateCountLabel(characterCount: Int) {
        textCountLabel.text = "\(characterCount)/\(maxTextCount)"
        textCountLabel.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? .lightGray : .blue)
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reportListCount()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReportTableViewCell.reuseIdentifier, for: indexPath) as? ReportTableViewCell else { return UITableViewCell() }
        
        cell.bind(viewModel.getReportList(indexPath.row))
        cell.selectionStyle = .none
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ReportTableViewCell {
            cell.showCellComponent()
            if indexPath.row == 4 {
                // MARK: - 그 외 기타사유 클릭시, 나중에 인덱스가 아닌 타입으로 리팩토링 진행 필요
                etcReportTextView.isHidden = false
                etcReportLabel.isHidden = false
                textCountLabel.isHidden = false
            } else {
                etcReportTextView.isHidden = true
                etcReportLabel.isHidden = true
                textCountLabel.isHidden = true
            }
        }
        
        for visibleIndexPath in tableView.indexPathsForVisibleRows ?? [] {
            if visibleIndexPath != indexPath,
               let cell = tableView.cellForRow(at: visibleIndexPath) as? ReportTableViewCell {
                cell.hiddenCellComponet()
            }
        }
        
        // 선택된 셀 뷰모델에 저장하고 있다가 제출 누르면 서버 전송되도록
    }
}

extension ReportViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = DesignSystemAsset.gray900.color
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = DesignSystemAsset.gray400.color
            updateCountLabel(characterCount: 0)
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= maxTextCount else { return false }
        updateCountLabel(characterCount: characterCount)

        return true
    }
}
