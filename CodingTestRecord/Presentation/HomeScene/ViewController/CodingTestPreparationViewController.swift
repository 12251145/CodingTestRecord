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
    
    private lazy var startMessageLabel: UILabel = {
        let label = UILabel()
        
        label.text = "시작합니다"
        label.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        
        return label
    }()
    
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
        
        view.addSubview(startMessageLabel)
        startMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.startMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.startMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func bindViewModel() {
        let _ = viewModel?.transform(
            from: CodingTestPreparationViewModel.Input(
                viewDidLoadEvent: Just(()).eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
    }
}
