//
//  DefaultRecordsCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import UIKit

final class DefaultRecordsCoordinator: RecordsCoordinator {
    var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var recordsViewController: RecordsViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .records }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.recordsViewController = RecordsViewController()
    }
    
    func start() {
        self.recordsViewController.viewModel = RecordsViewModel(
            coordinator: self,
            recordsUseCase: DefaultRecordsUseCase(
                codingTestResultRepository: DefaultCodingTestResultRepository(
                    coreDataService: DefaultCoreDataService.shared
                )
            )
        )
        self.navigationController.pushViewController(self.recordsViewController, animated: true)
    }
    
    
}
