//
//  CodingTestPreparationViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import UIKit

final class CodingTestPreparationViewController: UIViewController {
    var viewModel: CodingTestPreparationViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
}

private extension CodingTestPreparationViewController {
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
    }
    
    func bindViewModel() {
        let _ = viewModel?.transform(
            from: CodingTestPreparationViewModel.Input(),
            subscriptions: &subscriptions
        )
    }
}
