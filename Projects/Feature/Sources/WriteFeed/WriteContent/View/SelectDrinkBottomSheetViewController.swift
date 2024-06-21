//
//  SelectDrinkBottomSheetViewController.swift
//  Feature
//
//  Created by 김유진 on 3/30/24.
//

import Combine
import UIKit
import Service
import DesignSystem

final class SelectDrinkBottomSheetViewController: BaseViewController {
    private var cancelBag = Set<AnyCancellable>()
    
    weak var delegate: OnSelectedValue?
    
    private lazy var viewModel = SelectDrinkViewModel()
    
    private let bottomHeight: CGFloat = moderateScale(number: 392)

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
        $0.text = "술"
        $0.font = Font.bold(size: 24)
        $0.textColor = DesignSystemAsset.gray900.color
    }
    
    private lazy var snackSortTableView = UITableView().then {
        $0.backgroundColor = DesignSystemAsset.gray100.color
        $0.register(SnackSortTableViewCell.self, forCellReuseIdentifier: SnackSortTableViewCell.reuseIdentifier)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.rowHeight = moderateScale(number: 48)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .clear
        
        setupGestureRecognizer()
        
        viewModel.setCompletedSnackDataPublisher()
            .sink { [weak self] _ in
                self?.snackSortTableView.reloadData()
            }
            .store(in: &cancelBag)
        
        viewModel.sendPairingsValue(.drink)
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
            snackSortTableView
        ])
    }
    
    override func makeConstraints() {
        dimmedBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
            $0.leading.equalToSuperview().inset(moderateScale(number: 36))
        }
        
        snackSortTableView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetTitleLabel.snp.bottom).offset(moderateScale(number: 8))
            $0.leading.trailing.bottom.equalToSuperview().inset(moderateScale(number: 12))
        }
    }
}

extension SelectDrinkBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSourceCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SnackSortTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SnackSortTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.bind(viewModel.getDataSource(indexPath.row))
        
        cell.cellBackButton.setOpaqueTapGestureRecognizer { [weak self] in
            guard let selfRef = self else { return }
            
            let selectedDrink = selfRef.viewModel.getDataSource(indexPath.row)
            selfRef.delegate?.selectedValue(["selectedDrink": selectedDrink])
            
            selfRef.hideBottomSheetAndGoBack()
        }
        
        return cell
    }
}

// MARK: 바텀시트 노출 / 미노출
extension SelectDrinkBottomSheetViewController {
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
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
extension SelectDrinkBottomSheetViewController {
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
