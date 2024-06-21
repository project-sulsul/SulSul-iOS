//
//  ReportViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/12/25.
//

import UIKit
import SnapKit
import DesignSystem
import Combine

protocol ReportViewControllerDelegate: AnyObject {
    func reportIsComplete()
}

public final class ReportViewController: HiddenTabBarBaseViewController {

    var coordinator: CommonBaseCoordinator?
    var delegate: ReportViewControllerDelegate
    private let viewModel: ReportViewModel
    
    private var cancelBag = Set<AnyCancellable>()
    private var buttonBottomConstraint: Constraint?
    private let textViewPlaceHolder = "텍스트를 입력하세요"
    private let maxTextCount: Int = 100
    private lazy var superViewInset = moderateScale(number: 20)
    
    init(viewModel: ReportViewModel, delegate: ReportViewControllerDelegate) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var topHeaderView = BaseTopView()
    
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
    
    private lazy var contentScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }
    
    private lazy var containerView = UIView()
    
    private lazy var reportCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then({
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.registerCell(ReportCell.self)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
    })
    
    private func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(moderateScale(number: 52)))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(moderateScale(number: 52)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
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
        $0.layer.cornerRadius = moderateScale(number: 12)
        $0.clipsToBounds = true
        $0.setClickable(false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
        
        addViews()
        makeConstraints()
        bind()
    }
    
    public override func addViews() {
        super.addViews()
        view.addSubviews([topHeaderView,
                          contentScrollView,
                          submitTouchableLabel])
        contentScrollView.addSubview(containerView)
        containerView.addSubviews([titleLabel,
                                   subTitleLabel,
                                   reportCollectionView,
                                   etcReportTextView,
                                   etcReportLabel])
    }
    
    public override func makeConstraints() {
        super.makeConstraints()
        
        topHeaderView.snp.makeConstraints {
            $0.height.equalTo(moderateScale(number: 52))
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(topHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(submitTouchableLabel.snp.top)
        }
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalToSuperview().inset(superViewInset)
        }
        reportCollectionView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 272))
        }
        etcReportTextView.snp.makeConstraints {
            $0.top.equalTo(reportCollectionView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.height.equalTo(moderateScale(number: 120))
        }
        etcReportLabel.snp.makeConstraints {
            $0.top.equalTo(etcReportTextView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(superViewInset)
            $0.bottom.equalToSuperview()
        }
        submitTouchableLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.height.equalTo(moderateScale(number: 52))
            
            let offset = getSafeAreaBottom() + moderateScale(number: 12)
            buttonBottomConstraint = $0.bottom.equalToSuperview().inset(offset).constraint
        }
    }
    
    private func bind() {
        viewModel.getErrorSubject()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showAlertView(withType: .oneButton,
                                    title: error,
                                    description: error,
                                    submitCompletion: nil,
                                    cancelCompletion: nil)
            }.store(in: &cancelBag)
        
        viewModel.reportSuccessPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.delegate.reportIsComplete()
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancelBag)
        
        viewModel.reportReasonsPublisher()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                guard let self = self else { return }
                if let otherItem = response.first(where: { $0.title == .other && $0.isChecked }) {
                    self.etcReportTextView.isHidden = false
                    self.etcReportLabel.isHidden = false
                    self.submitTouchableLabel.setClickable(false)
                } else {
                    self.view.endEditing(true)
                    self.etcReportTextView.isHidden = true
                    self.etcReportLabel.isHidden = true
                    self.submitTouchableLabel.setClickable(true)
                }
                self.reportCollectionView.reloadData()
            }.store(in: &cancelBag)
    }
    
    public override func setupIfNeeded() {
        submitTouchableLabel.setOpaqueTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            if viewModel.currentReportContentValue() == ReportReason.other.rawValue {
                viewModel.setCurrentReportContent(etcReportTextView.text)
            }
            viewModel.sendReportContent()
        }
        
        topHeaderView.backTouchableView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        view.addGestureRecognizer(tapGestureRecognizer)
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
        topHeaderView.setTitle("신고하기")
        animateWithKeyboard(notification: notification) { [weak self] keyboardFrame in
            self?.buttonBottomConstraint?.update(inset: keyboardFrame.height + 10)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: NSNotification) {
        topHeaderView.setTitle("")
        animateWithKeyboard(notification: notification) { [weak self] _ in
            self?.buttonBottomConstraint?.update(inset: getSafeAreaBottom() + moderateScale(number: 12))
        }
    }
    
    @objc
    private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ReportViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = DesignSystemAsset.gray900.color
            submitTouchableLabel.setClickable(false)
        } else {
            submitTouchableLabel.setClickable(true)
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = DesignSystemAsset.gray400.color
            submitTouchableLabel.setClickable(false)
        } else {
            submitTouchableLabel.setClickable(true)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            submitTouchableLabel.setClickable(false)
        } else {
            submitTouchableLabel.setClickable(true)
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= maxTextCount else { return false }

        return true
    }
}

extension ReportViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.reportListCount()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(ReportCell.self, indexPath: indexPath) else { return .init() }
        let reason = viewModel.getReportList()[indexPath.item]
        cell.bind(reason)
        cell.containerView.setOpaqueTapGestureRecognizer { [weak self] in
            self?.viewModel.selectReason(of: indexPath.item)
        }
        
        return cell
    }
}
