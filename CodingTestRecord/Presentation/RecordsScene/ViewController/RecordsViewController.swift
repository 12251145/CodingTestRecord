//
//  RecordsViewController.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import UIKit
import SwiftUI

final class RecordsViewController: UIViewController {
    var viewModel: RecordsViewModel?
    var subscriptions = Set<AnyCancellable>()
    var viewWillAppearEvent = PassthroughSubject<Void, Never>()
    var swipeToDeleteActionEventSubject = PassthroughSubject<Int, Never>()
    
    
    private lazy var hostingController: UIHostingController<CodingTestResultsBarChartView> = {
        let controller = UIHostingController(rootView: CodingTestResultsBarChartView(
            chartData: ChartData(series: [], correctAvg: 0, problemCountAvg: 0))
        )
        
        return controller
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CodingTestResultCell.self, forCellReuseIdentifier: "CodingTestResultCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearEvent.send(())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradientLayer.frame = CGRect(x: 0, y: 0, width: self.gradientContainerView.bounds.width, height: self.gradientContainerView.bounds.height / 2)
    }
}

// MARK: - Private Functions

private extension RecordsViewController {
    func configureUI() {
        view.backgroundColor = .white
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "기록"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always

        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        self.hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        self.hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            self.hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        view.addSubview(self.tableView)
        view.addSubview(self.gradientContainerView)
        self.gradientContainerView.layer.addSublayer(self.gradientLayer)
        self.gradientContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.hostingController.view.bottomAnchor, constant: 24),
            self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            self.gradientContainerView.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            self.gradientContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.gradientContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.gradientContainerView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
    }
    
    func bindViewModel() {
        let output = viewModel?.transform(
            from: RecordsViewModel.Input(
                viewWillAppearEvent: self.viewWillAppearEvent.eraseToAnyPublisher(),
                swipeToDeleteActionEvent: self.swipeToDeleteActionEventSubject.eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
        
        output?.loadData
            .filter { $0 }
            .sink(receiveValue: { _ in
                self.tableView.reloadData()
            })
            .store(in: &subscriptions)
        
        output?.chartData
            .sink(receiveValue: { chartData in
                self.hostingController.rootView = CodingTestResultsBarChartView(
                    chartData: chartData
                )
            })
            .store(in: &subscriptions)
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.codingTestResults.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CodingTestResultCell",
            for: indexPath
        ) as? CodingTestResultCell else {
            return UITableViewCell()
        }
        
        let codingTestResult = self.viewModel?.codingTestResults[indexPath.row]
        
        
        cell.contentConfiguration = UIHostingConfiguration {
            CodingTestResultCellView(codingTestResult: codingTestResult!)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil, handler: { action, view, completionHandler in
            self.swipeToDeleteActionEventSubject.send(indexPath.row)
            completionHandler(true)
        })
        
        action.image = UIImage(systemName: "trash.fill")
        action.backgroundColor = .systemGray2
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
    
    
}
