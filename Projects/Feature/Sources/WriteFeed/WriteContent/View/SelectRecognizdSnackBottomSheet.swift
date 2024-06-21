//
//  SelectRecognizdSnackBottomSheet.swift
//  Feature
//
//  Created by 김유진 on 3/30/24.
//
 
import Combine
import UIKit
import Service
import DesignSystem

final class SelectRecognizdSnackBottomSheet: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    weak var delegate: OnSelectedValue?
    
    private lazy var viewModel = SelectSnackViewModel(selectSnackType: .bottomSheet)
    
    private let bottomHeight: CGFloat = UIScreen.main.bounds.height - 68

    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    private lazy var dimmedBackView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        $0.alpha = 0.0
    }
    
    private lazy var bottomSheetView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.layer.cornerRadius = moderateScale(number: 24)
    }
    
    private lazy var grabView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.gray300.color
        $0.layer.cornerRadius = moderateScale(number: 3)
    }
    
    private lazy var bottomSheetTitleLabel = UILabel().then {
        $0.text = "안주 선택"
        $0.font = Font.semiBold(size: 16)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var selectSnackView = SelectSnackView(delegate: self,
                                                       viewModel: viewModel,
                                                       isEditView: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectSnackView.didTabSnack = self
    
        view.backgroundColor = .clear
        
        setupGestureRecognizer()
        
        viewModel.setCompletedSnackDataPublisher()
            .sink { [weak self] in
                self?.selectSnackView.snackTableView.reloadData()
            }
            .store(in: &cancelBag)
        
        viewModel.searchResultCountDataPublisher().sink { [weak self] searchResultCount in
            self?.selectSnackView.resultEmptyView.isHidden = !(searchResultCount == 0)
            self?.selectSnackView.snackTableView.isHidden = searchResultCount == 0
        }
        .store(in: &cancelBag)
        
        selectSnackView.resultEmptyView.addSnackButton.onTapped { [weak self] in
            let vc = AddSnackViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }

    
    override func addViews() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        
        bottomSheetView.addSubviews([
            grabView,
            bottomSheetTitleLabel,
            selectSnackView
        ])
    }
    
    override func makeConstraints() {
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetViewTopConstraint = bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            bottomSheetView.heightAnchor.constraint(equalToConstant: bottomHeight),
            bottomSheetViewTopConstraint
        ])
        
        grabView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(moderateScale(number: 12))
            $0.width.equalTo(moderateScale(number: 40))
            $0.height.equalTo(moderateScale(number: 6))
            $0.centerX.equalToSuperview()
        }
        
        bottomSheetTitleLabel.snp.makeConstraints {
            $0.top.equalTo(grabView.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.equalToSuperview().inset(moderateScale(number: 20))
        }
        
        selectSnackView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetTitleLabel.snp.bottom).offset(moderateScale(number: 18))
            $0.bottom.equalToSuperview().inset(moderateScale(number: 12))
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: 바텀시트 노출 / 미노출
extension SelectRecognizdSnackBottomSheet {
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        let bottomSheetBottomInset = moderateScale(number: 42)
        
        bottomSheetViewTopConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

// MARK: 제스처
extension SelectRecognizdSnackBottomSheet {
    private func setupGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    @objc func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
}

extension SelectRecognizdSnackBottomSheet: OnSelectedValue {
    func selectedValue(_ value: [String : Any]) {
        guard let selectedValue = value["selectedValue"] as? SnackModel else { return }
        
        delegate?.selectedValue(["selectedSnack": selectedValue])
        hideBottomSheetAndGoBack()
    }
}

extension SelectRecognizdSnackBottomSheet: SearchSnack {
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
