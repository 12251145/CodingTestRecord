//
//  CodingTestingViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import UIKit

final class CodingTestingViewController: UIViewController {
    var viewModel: CodingTestingViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Private Functions
private extension CodingTestingViewController {
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func bindViewModel() {
        let _ = self.viewModel?.transform(
            from: CodingTestingViewModel.Input(),
            subscriptions: &subscriptions
        )
    }
}
