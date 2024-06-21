//
//  test.swift
//  ProjectDescriptionHelpers
//
//  Created by 이범준 on 2023/08/23.
//

import UIKit
import DesignSystem
import Then
import SnapKit
import Service
import Combine

public final class SplashViewController: BaseViewController {
    var coordinator: MainBaseCoordinator?
    
    private let viewModel: SplashViewModel
    private var cancelBag = Set<AnyCancellable>()
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "sulsul")
        $0.backgroundColor = .clear
    }
    
    private lazy var titleLabel = UILabel().then({
        $0.text = "술을 맛있고 즐겁게!"
        $0.textColor = DesignSystemAsset.white.color
        $0.font = Font.bold(size: 20)
        $0.setLineHeight(32, font: Font.bold(size: 20))
        $0.numberOfLines = 0
    })
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystemAsset.black.color
            
        viewModel.splashIsCompletedPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if KeychainStore.shared.read(label: "accessToken") != nil {
                    StaticValues.isLoggedIn.send(true)
                } else {
                    StaticValues.isLoggedIn.send(false)
                }
                coordinator?.moveTo(appFlow: AppFlow.tabBar(.home(.main)), userData: nil)
            }.store(in: &cancelBag)
    }
    public override func addViews() {
        view.addSubviews([
            self.titleLabel,
            self.imageView
        ])
    }
    
    public override func makeConstraints() {
        self.titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(self.imageView.snp.top).offset(-moderateScale(number: 24))
            $0.centerX.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(moderateScale(number: 256))
            $0.height.equalTo(moderateScale(number: 37))
        }
    }
   
}
