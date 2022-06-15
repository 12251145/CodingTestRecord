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
                codingTestSettingRepository: DefaultCodingTestSettingRepository(coreDataService: DefaultCoreDataService())
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
}

extension DefaultHomeCoordinator: CoordinatorDidFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

extension DefaultHomeCoordinator: SettingCoordinatorDidFinishDelegate {
    func settingCoordinatorDidFinish(with settingData: CodingTestSetting) {
        // codingTesting 플로우로 가야함
    }
    
    
}
