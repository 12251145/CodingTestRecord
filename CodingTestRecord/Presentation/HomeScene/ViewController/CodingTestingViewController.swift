//
//  CodingTestingViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import SwiftUI
import UIKit

final class CodingTestingViewController: UIViewController {
    var viewModel: CodingTestingViewModel?
    var subscriptions = Set<AnyCancellable>()
    var passUpdateEvent = PassthroughSubject<(Int, PassKind, Bool), Never>()
    
    
    
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
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var endButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "종료"
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var devider: UIView = {
        let rect = UIView()
        
        rect.backgroundColor = .secondarySystemBackground
        
        return rect
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CodingTestingViewCell.self, forCellReuseIdentifier: "CodingTestingViewCell")
        
        return tableView
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
        self.navigationItem.title = "타이틀 와야 함"
        
        view.addSubview(self.timerLabel)
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height / 7),
            self.timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(progressView)
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.progressView.topAnchor.constraint(equalTo: self.timerLabel.bottomAnchor, constant: 50),
            self.progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.progressView.bottomAnchor, constant: 110),
            self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.view.addSubview(self.devider)
        self.devider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.devider.bottomAnchor.constraint(equalTo: self.tableView.topAnchor),
            self.devider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.devider.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.devider.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        view.addSubview(self.cancelEndButtonHStack)
        self.cancelEndButtonHStack.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.endButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.cancelEndButtonHStack.addArrangedSubview(self.cancelButton)
        self.cancelEndButtonHStack.addArrangedSubview(self.endButton)
        
        NSLayoutConstraint.activate([
            self.cancelEndButtonHStack.bottomAnchor.constraint(equalTo: self.tableView.topAnchor, constant: -20),
            self.cancelEndButtonHStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.cancelEndButtonHStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            self.cancelButton.heightAnchor.constraint(equalToConstant: 50),
            self.endButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func bindViewModel() {
        let output = self.viewModel?.transform(
            from: CodingTestingViewModel.Input(
                passUpdateEvent: self.passUpdateEvent.eraseToAnyPublisher(),
                viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
                cancelButtonDidTap: self.cancelButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
                endButtonDidTap: self.endButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
        
        output?.title
            .sink(receiveValue: { [weak self] title in
                self?.navigationItem.title = title
            })
            .store(in: &subscriptions)
        
        output?.leftTime
            .sink(receiveValue: { [weak self] leftTime in
                self?.timerLabel.text = leftTime.hhmmss
            })
            .store(in: &subscriptions)
        
        output?.progress
            .sink(receiveValue: { [weak self] progress in
                self?.progressView.setProgress(progress, animated: true)
            })
            .store(in: &subscriptions)
    }
    
    func createProgressView() -> UIProgressView {
        return TimerProgressView(width: UIScreen.main.bounds.width * 0.8, color: .systemPink)
    }
}

extension CodingTestingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.width / 5.5) + 32
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.problems.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CodingTestingViewCell",
            for: indexPath) as? CodingTestingViewCell else { return UITableViewCell() }

        if let problem = self.viewModel?.problems[indexPath.row] {
            
            cell.viewModel = CodingTestingCellViewModel(
                delegate: self,
                codingTesingCellUseCase: DefaultCodingTestingCellUseCase(
                    index: indexPath.row, problem: problem
                )
            )
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CodingTestingViewController: CodingTestingCellDelegate {
    func updatePassState(index: Int, kind: PassKind, isPass: Bool) {
        self.passUpdateEvent.send((index, kind, isPass))
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}
