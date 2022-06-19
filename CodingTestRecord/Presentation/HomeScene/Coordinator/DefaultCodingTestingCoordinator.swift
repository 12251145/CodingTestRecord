//
//  DefaultCodingTestingCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import UIKit

final class DefaultCodingTestingCoordinator: CodingTestingCoordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .codingTesting }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(with settingData: CodingTestSetting) {
        pushCodingTestingViewController(with: settingData)
    }
    
    func pushCodingTestingViewController(with settingData: CodingTestSetting) {
        let codingTestingViewController = CodingTestingViewController()
        codingTestingViewController.viewModel = CodingTestingViewModel(
            coordinator: self,
            codingTestSettingUseCase: DefaultCodingTestingUseCase(
                codingTestResultRepository: DefaultCodingTestResultRepository(coreDataService: DefaultCoreDataService.shared),
                codingTestSetting: settingData
            )
        )
        
        
        self.navigationController.pushViewController(codingTestingViewController, animated: true)
    }
    
    func pushCodingTestResultViewController(with result: CodingTesting) {
        let codingTestResultViewController = CodingTestResultViewController()
        codingTestResultViewController.viewModel = CodingTestResultViewModel(
            coordinator: self,
            codingTestResultUseCase: DefaultCodingTestResultUseCase(
                codingTestResultRepository: DefaultCodingTestResultRepository(coreDataService: DefaultCoreDataService.shared),
                codingTesting: result
            )
        )
        
        self.navigationController.pushViewController(codingTestResultViewController, animated: true)
    }
}
