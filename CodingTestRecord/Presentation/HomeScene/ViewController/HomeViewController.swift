//
//  HomeViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import UIKit
import SwiftUI

final class HomeViewController: UIViewController {
    var viewModel: HomeViewModel?
    var subscriptions = Set<AnyCancellable>()
    var tableViewCellDidSelectedSubject = PassthroughSubject<Int, Never>()
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "코딩 테스트"
        label.font = UIFont.systemFont(ofSize: 37, weight: .bold)
        
        return label
    }()
    
    private lazy var addCodingTestButton: UIButton = {
        var button = UIButton()
        var config = UIButton.Configuration.filled()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .large)
        
        config.image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        config.baseForegroundColor = .systemPink
        config.baseBackgroundColor = .white
        config.cornerStyle = .capsule
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .secondarySystemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        
        return tableView
    }()
    
    private lazy var gradientContainerView: UIView = {
        let container = UIView()
        
        container.backgroundColor = .clear
        
        return container
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        
        layer.colors = [
            UIColor.secondarySystemBackground.withAlphaComponent(1).cgColor,
            UIColor.secondarySystemBackground.withAlphaComponent(0).cgColor
        ]
        
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.gradientContainerView.bounds.width, height: self.gradientContainerView.bounds.height / 2)
    }
}

// MARK: - Private Functions

private extension HomeViewController {
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem()
        
        // titleLabel
        view.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
        ])
        
        // addCodingTestButton
        view.addSubview(self.addCodingTestButton)
        self.addCodingTestButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.addCodingTestButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.addCodingTestButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            self.addCodingTestButton.widthAnchor.constraint(equalToConstant: 40),
            self.addCodingTestButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        // tableView
        view.addSubview(self.tableView)
        view.addSubview(self.gradientContainerView)
        self.gradientContainerView.layer.addSublayer(self.gradientLayer)
        self.gradientContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
    
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            self.gradientContainerView.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            self.gradientContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.gradientContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.gradientContainerView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func bindViewModel() {
        let output = viewModel?.transform(input: HomeViewModel.Input(
            viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
            addCodingTestButtonDidTap: self.addCodingTestButton.publisher(for: .touchUpInside).eraseToAnyPublisher(),
            tableViewCellDidSelected: self.tableViewCellDidSelectedSubject.eraseToAnyPublisher()
        ), subscriptions: &subscriptions)
        
        output?.addButtonDidTap
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.codingTestSettings.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let codingTestSetting = self.viewModel?.codingTestSettings[indexPath.row]
        
        cell.contentConfiguration = UIHostingConfiguration {
            CodingTestCellView(setting: codingTestSetting!)
        }
        .background(Color(.secondarySystemBackground))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableViewCellDidSelectedSubject.send(indexPath.row)
    }
}
