//
//  DefaultCodingTestingCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import UIKit

final class DefaultCodingTestingCoordinator: CodingTestingCoordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
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
            codingTestSettingUseCase: DefaultCodingTestingUseCase(codingTestSetting: settingData)
        )
        
        
        self.navigationController.pushViewController(codingTestingViewController, animated: true)
    }
}
