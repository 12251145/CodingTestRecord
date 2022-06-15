//
//  ProblemsSettingViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import UIKit

final class ProblemsSettingViewController: UIViewController {
    var viewModel: ProblemsSettingViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "다음"
        
        button.configuration = config
        
        return button
    }()
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
}

// MARK: - Private Functions
private extension ProblemsSettingViewController {
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "문제 설정"
        
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.nextButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func bindViewModel() {
        let _ = viewModel?.transform(
            from: ProblemsSettingViewModel.Input(
                viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
                nextButtonDidTap: self.nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
    }
}
