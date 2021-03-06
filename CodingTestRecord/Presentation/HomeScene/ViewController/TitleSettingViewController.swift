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
    var keyboardMonitor : KeyboardMonitor?
    var subscriptions = Set<AnyCancellable>()
    
    private var nextButtonBottomConstraint: NSLayoutConstraint?
    
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
            string: "..."
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
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tap)
        
        keyboardMonitor = KeyboardMonitor()
        observingKeyboardEvent()
        self.titleTextField.delegate = self
        
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
            self.noticeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 6),
            self.noticeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        self.view.addSubview(self.titleTextField)
        self.titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleTextField.topAnchor.constraint(equalTo: self.noticeLabel.bottomAnchor, constant: 80),
            self.titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.titleTextField.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        self.view.addSubview(self.nextButton)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButtonBottomConstraint = self.nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            self.nextButtonBottomConstraint!,
            self.nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.nextButton.heightAnchor.constraint(equalToConstant: 50)
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

// MARK: - KeyboardEvent
private extension TitleSettingViewController {
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func observingKeyboardEvent() {
        keyboardMonitor?.$keyboardHeight
            .sink(receiveValue: { height in
                self.nextButtonBottomConstraint?.constant = height > 0 ? (-height + 20) : 0
                self.view.layoutIfNeeded()
            })
            .store(in: &subscriptions)
    }
}
 
extension TitleSettingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
