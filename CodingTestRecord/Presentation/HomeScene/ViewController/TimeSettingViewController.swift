//
//  TimeSettingViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import UIKit

final class TimeSettingViewController: UIViewController {
    var viewModel: TimeSettingViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "완료"
        config.baseBackgroundColor = .systemGray3
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "시작"
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let hStack = UIStackView()
        
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 10
        
        return hStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
}


// MARK: - Private Functions
private extension TimeSettingViewController {
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "시간 설정"
        
        view.addSubview(self.buttonHStackView)
        self.buttonHStackView.translatesAutoresizingMaskIntoConstraints = false
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.buttonHStackView.addArrangedSubview(self.doneButton)
        self.buttonHStackView.addArrangedSubview(self.startButton)
        
        NSLayoutConstraint.activate([
            self.buttonHStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.buttonHStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.buttonHStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            self.doneButton.heightAnchor.constraint(equalToConstant: 44),
            self.startButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func bindViewModel() {
        let _ = viewModel?.transform(
            from: TimeSettingViewModel.Input(
                doneButtonDidTap: self.doneButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
                startButtonDidTap: self.startButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
    }
}
