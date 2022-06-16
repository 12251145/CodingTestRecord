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
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        
        label.text = "00:00:00"
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        
        return label
    }()
    
    private(set) lazy var progressView = self.createProgressView()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "취소"
        config.baseBackgroundColor = .black
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var endButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "종료"
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var cancelEndButtonHStack: UIStackView = {
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
private extension CodingTestingViewController {
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        
        view.addSubview(self.timerLabel)
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 6),
            self.timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(progressView)
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.progressView.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor, constant: 40),
            self.progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(self.cancelEndButtonHStack)
        self.cancelEndButtonHStack.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.endButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.cancelEndButtonHStack.addArrangedSubview(self.cancelButton)
        self.cancelEndButtonHStack.addArrangedSubview(self.endButton)
        
        NSLayoutConstraint.activate([
            self.cancelEndButtonHStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.cancelEndButtonHStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.cancelEndButtonHStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            self.cancelButton.heightAnchor.constraint(equalToConstant: 44),
            self.endButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func bindViewModel() {
        let _ = self.viewModel?.transform(
            from: CodingTestingViewModel.Input(),
            subscriptions: &subscriptions
        )
    }
    
    func createProgressView() -> UIProgressView {
        return TimerProgressView(width: UIScreen.main.bounds.width * 0.8, color: .systemPink)
    }
}
