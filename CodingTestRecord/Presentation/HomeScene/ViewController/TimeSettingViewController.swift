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
    
    
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.text = "시간을 설정해보세요."
        
        
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        timeLabel.textColor = .black
        timeLabel.text = "3시간 30분"
        
        return timeLabel
    }()
    
    private lazy var timePlusButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        config.image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        config.baseForegroundColor = .systemPink
        config.baseBackgroundColor = .secondarySystemBackground
        config.cornerStyle = .capsule
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var timeSubstractButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .medium)
        
        config.image = UIImage(systemName: "minus", withConfiguration: imageConfig)
        config.baseForegroundColor = .systemPink
        config.baseBackgroundColor = .secondarySystemBackground
        config.cornerStyle = .capsule
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowOpacity = 0.5
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var timeButtonHStack: UIStackView = {
        var stack = UIStackView()
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "완료"
        config.baseBackgroundColor = .black
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "시작"
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var doneStartButtonHStack: UIStackView = {
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
        
        view.addSubview(self.noticeLabel)
        self.noticeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.noticeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 5),
            self.noticeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(self.timeLabel)
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 80),
            self.timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(timeButtonHStack)
        self.timeButtonHStack.translatesAutoresizingMaskIntoConstraints = false
        self.timePlusButton.translatesAutoresizingMaskIntoConstraints = false
        self.timeSubstractButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.timeButtonHStack.addArrangedSubview(self.timeSubstractButton)
        self.timeButtonHStack.addArrangedSubview(self.timePlusButton)
        
        NSLayoutConstraint.activate([
            self.timeButtonHStack.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 3),
            self.timeButtonHStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.timeButtonHStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            self.timePlusButton.widthAnchor.constraint(equalToConstant: 52),
            self.timePlusButton.heightAnchor.constraint(equalToConstant: 52),
            
            self.timeSubstractButton.widthAnchor.constraint(equalToConstant: 52),
            self.timeSubstractButton.heightAnchor.constraint(equalToConstant: 52),
        ])
        
        
        view.addSubview(self.doneStartButtonHStack)
        self.doneStartButtonHStack.translatesAutoresizingMaskIntoConstraints = false
        self.doneButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.doneStartButtonHStack.addArrangedSubview(self.doneButton)
        self.doneStartButtonHStack.addArrangedSubview(self.startButton)
        
        NSLayoutConstraint.activate([
            self.doneStartButtonHStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.doneStartButtonHStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.doneStartButtonHStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            self.doneButton.heightAnchor.constraint(equalToConstant: 50),
            self.startButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func bindViewModel() {
        let output = viewModel?.transform(
            from: TimeSettingViewModel.Input(
                viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
                timePlusButtonDidTap: self.timePlusButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
                timeSbustractButtonDidTap: self.timeSubstractButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
                doneButtonDidTap: self.doneButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
                startButtonDidTap: self.startButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
        
        output?.timeLimit
            .sink(receiveValue: { [weak self] newTime in
                self?.timeLabel.text = newTime
            })
            .store(in: &subscriptions)
    }
}
