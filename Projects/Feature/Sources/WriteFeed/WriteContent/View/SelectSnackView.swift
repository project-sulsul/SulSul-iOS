//
//  SelectSnackView.swift
//  Feature
//
//  Created by 김유진 on 3/31/24.
//

import DesignSystem
import UIKit

final class SelectSnackView: UIView {
    var viewModel: SelectSnackViewModel!
    var searchBarView: SearchBarView!
    
    weak var didTabSnack: OnSelectedValue?
    
    private lazy var isEditView = false

    lazy var snackTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = DesignSystemAsset.black.color
        $0.register(SnackTableViewCell.self, forCellReuseIdentifier: SnackTableViewCell.reuseIdentifier)
        $0.register(SnackSortHeaderView.self, forHeaderFooterViewReuseIdentifier: SnackSortHeaderView.id)
        $0.register(SnackFooterLineView.self, forHeaderFooterViewReuseIdentifier: SnackFooterLineView.id)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.sectionFooterHeight = 0
        $0.rowHeight = moderateScale(number: 52)
    }
    
    lazy var resultEmptyView = SearchResultEmptyView().then {
        $0.isHidden = true
    }
    
    convenience init(delegate: SearchSnack?,
                     viewModel: SelectSnackViewModel,
                     isEditView: Bool = false) {
        
        self.init(frame: .zero)
        
        self.isEditView = isEditView
        self.searchBarView = SearchBarView(delegate: delegate)
        
        if isEditView {
            self.searchBarView.backgroundColor = DesignSystemAsset.gray100.color
            self.snackTableView.backgroundColor = DesignSystemAsset.gray100.color
        }
        
        self.viewModel = viewModel
        
        layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubviews([
            searchBarView,
            snackTableView,
            resultEmptyView
        ])
        
        searchBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.top.equalToSuperview()
            $0.height.equalTo(moderateScale(number: 48))
        }
        
        snackTableView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(moderateScale(number: 16))
            $0.leading.trailing.equalToSuperview().inset(moderateScale(number: 20))
            $0.bottom.equalToSuperview()
        }
        
        resultEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(moderateScale(number: 74))
            $0.centerX.equalToSuperview()
        }
    }
}

extension SelectSnackView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.snackSectionModelCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.snackSectionModel(in: section).cellModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SnackTableViewCell.reuseIdentifier, for: indexPath) as? SnackTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.bind(snack: viewModel.snackSectionModel(in: indexPath.section).cellModels[indexPath.row])
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSnackCellModel = viewModel.snackSectionModel(in: indexPath.section).cellModels[indexPath.row]
        
        if selectedSnackCellModel.isSelect == true {
            viewModel.changeSelectedState(isSelect: false, indexPath: indexPath)
            
        } else if viewModel.selectedSnackCount() < 5 {
            viewModel.changeSelectedState(isSelect: true, indexPath: indexPath)
        } else {
            didTabSnack?.selectedValue(["shouldShowErrorAlert": ()])
        }

        if isEditView {
            didTabSnack?.selectedValue(["selectedValue": selectedSnackCellModel])
            
        } else {
            didTabSnack?.selectedValue(["shouldSetCount": ()])
        }

        snackTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SnackSortHeaderView.id) as? SnackSortHeaderView else { return nil }
        
        header.bind(viewModel.snackSectionModel(in: section).headerModel)
        
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: SnackFooterLineView.id) as? SnackFooterLineView else { return nil }

        return footer
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return moderateScale(number: 33)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return moderateScale(number: 22)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        endEditing(true)
    }
}
