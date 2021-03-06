//
//  DefaultHomeCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import UIKit

final class DefaultHomeCoordinator: HomeCoordinator {
    var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var homeViewController: HomeViewController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .home }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.homeViewController = HomeViewController()
    }
    
    func start() {
        self.homeViewController.viewModel = HomeViewModel(
            coordinator: self,
            homeUseCase: DefaultHomeUseCase(
                codingTestSettingRepository: DefaultCodingTestSettingRepository(coreDataService: DefaultCoreDataService.shared)
            )
        )
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func showSettingFlow(with settingData: CodingTestSetting) {
        let settingCoordinator = DefaultCodingTestSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        settingCoordinator.settingFinishDelegate = self
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start(with: settingData)
    }
    
    func showCodingTestingFlow(with settingData: CodingTestSetting) {
        let codingTestingCoordinator = DefaultCodingTestingCoordinator(self.navigationController)
        codingTestingCoordinator.finishDelegate = self
        self.childCoordinators.append(codingTestingCoordinator)
        codingTestingCoordinator.start(with: settingData)
    }
}

extension DefaultHomeCoordinator: CoordinatorDidFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        
        childCoordinator.navigationController.navigationBar.prefersLargeTitles = false
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

extension DefaultHomeCoordinator: SettingCoordinatorDidFinishDelegate {
    func settingCoordinatorDidFinish(with settingData: CodingTestSetting) {

        self.showCodingTestingFlow(with: settingData)
    }
}
