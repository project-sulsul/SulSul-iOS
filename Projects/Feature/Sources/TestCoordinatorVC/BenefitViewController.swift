//
//  BenefitViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/22.
//

import UIKit
import DesignSystem

final class BenefitViewController: BaseViewController {
    var coordinator: BenefitBaseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
