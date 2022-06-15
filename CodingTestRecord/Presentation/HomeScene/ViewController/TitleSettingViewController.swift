//
//  TitleSettingViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Combine
import UIKit

final class TitleSettingViewController: UIViewController {
    var viewModel: TitleSettingViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    private lazy var noticeLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.text = "타이틀을 입력해주세요."
        
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = CursorDisabledTextField()
        let attributedString = NSAttributedString(
            string: self.viewModel?.codingTestSettingUseCase.codingTestSetting.value.title ?? "..."
        )
        
        textField.borderStyle = .none
        textField.attributedText = attributedString
        textField.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        textField.textAlignment = .center
        textField.placeholder = "타이틀"
        
        
        return textField
    }()
    
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

private extension TitleSettingViewController {
    func configureUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "타이틀"
        
        self.view.addSubview(self.noticeLabel)
        self.noticeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.noticeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            self.noticeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        self.view.addSubview(self.titleTextField)
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleTextField.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 40),
            self.titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.titleTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -400),
            self.nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.nextButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func bindViewModel() {
        let output = viewModel?.transform(from:
                                            TitleSettingViewModel.Input(
                                                viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
                                                titleTextField: self.titleTextField.controlPublisher(for: .editingChanged)
                                                    .eraseToAnyPublisher(),
                                                nextButtonDidTap: self.nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
                                            ),
                                          subscriptions: &subscriptions)
        
        output?.titleTextField
            .sink(receiveValue: { [weak self] text in
                self?.updateTitleText(with: text)
            })
            .store(in: &subscriptions)
    }
    
    func updateTitleText(with text: String) {
        self.titleTextField.attributedText = NSAttributedString(string: text)
    }
}
