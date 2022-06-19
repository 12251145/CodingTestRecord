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
    
    
    private lazy var hostingController: UIHostingController<CodingTestResultsBarChartView> = {
        let controller = UIHostingController(rootView: CodingTestResultsBarChartView(
            chartData: ChartData(series: [], correctAvg: 0, problemCountAvg: 0))
        )
        
        
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearEvent.send(())
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
            self.hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
    
    func bindViewModel() {
        let output = viewModel?.transform(
            from: RecordsViewModel.Input(
                viewWillAppearEvent: self.viewWillAppearEvent.eraseToAnyPublisher()
            ),
            subscriptions: &subscriptions
        )
        
        output?.chartData
            .sink(receiveValue: { chartData in
                self.hostingController.rootView = CodingTestResultsBarChartView(
                    chartData: chartData
                )
            })
            .store(in: &subscriptions)
    }
}
