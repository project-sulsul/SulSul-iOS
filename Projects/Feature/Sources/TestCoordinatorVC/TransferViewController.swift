//
//  TransferViewController.swift
//  Feature
//
//  Created by 이범준 on 2023/11/23.
//

import UIKit
import DesignSystem

final class TransferViewController: BaseViewController {
    var coordinator: WriteFeedBaseCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
}
