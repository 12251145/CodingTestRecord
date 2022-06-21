//
//  CodingTestResultViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import UIKit

final class CodingTestResultViewController: UIViewController {
    var viewModel: CodingTestResultViewModel?
    var subscriptions = Set<AnyCancellable>()
    
    
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .large
        config.title = "확인"
        
        button.configuration = config
        
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        return button
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        
        label.text = "3.0"
        
        label.font = UIFont.systemFont(ofSize: 80, weight: .semibold)
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        label.layer.shadowOpacity = 0.5
        label.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        
        label.text = "5.0"
        
        label.textColor = .secondarySystemBackground
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        
        
        return label
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
        tableView.register(CodingTestTimelineCell.self, forCellReuseIdentifier: "CodingTestTimelineCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModle()
    }
}

// MARK: - Private Functions
private extension CodingTestResultViewController {
    func configureUI() {
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "타이틀"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        
        view.backgroundColor = .white
        
        self.view.addSubview(self.scoreLabel)
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.totalLabel)
        self.totalLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.totalLabel.topAnchor.constraint(equalTo: self.scoreLabel.bottomAnchor, constant: -10),
            self.totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        self.view.addSubview(self.devider)
        self.devider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.devider.topAnchor.constraint(equalTo: self.totalLabel.bottomAnchor, constant: 30),
            self.devider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.devider.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.devider.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.devider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.devider.bottomAnchor),
            self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.view.addSubview(self.okButton)
        self.okButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.okButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            self.okButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.okButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
    }
    
    func bindViewModle() {
        
        let output = self.viewModel?.transform(
            from: CodingTestResultViewModel.Input(
                viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
                okButtonDidTap: self.okButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
        
        output?.title
            .sink(receiveValue: { [weak self] title in
                self?.navigationItem.title = title
            })
            .store(in: &subscriptions)
        
        output?.score
            .sink(receiveValue: { [weak self] score in
                self?.scoreLabel.text = String(score)
            })
            .store(in: &subscriptions)
        
        output?.total
            .sink(receiveValue: { [weak self] total in
                self?.totalLabel.text = String(total)
            })
            .store(in: &subscriptions)
        
        output?.loadData
            .filter { $0 }
            .sink(receiveValue: { _ in
                self.tableView.reloadData()
            })
            .store(in: &subscriptions)
        
    }
}

extension CodingTestResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.width / 5.5) + 32
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.problemEvents.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CodingTestTimelineCell",
            for: indexPath
        ) as? CodingTestTimelineCell else {
            return UITableViewCell()
        }
        
        if let problemEvent = self.viewModel?.problemEvents[indexPath.row] {
            
            cell.viewModel = CodingTestTimelineCellViewModel(
                delegate: self,
                codingTestTimelineCellUseCase: DefaultCodingTestTimelineCellUseCase(
                    index: indexPath.row,
                    problemEvent: problemEvent
                )
            )
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

extension CodingTestResultViewController: CodingTestTimelineCellDelegate {
    
}
