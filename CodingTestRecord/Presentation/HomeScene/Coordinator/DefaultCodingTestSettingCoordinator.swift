//
//  DefaultCodingTestSettingCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import UIKit

final class DefaultCodingTestSettingCoordinator: CodingTestSettingCoordinator {
    weak var finishDelegate: CoordinatorDidFinishDelegate?
    weak var settingFinishDelegate: SettingCoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .codingTestSetting }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(with settingData: CodingTestSetting) {
        self.pushTitleSettingViewController(with: settingData)
    }
    
    func pushTitleSettingViewController(with settingData: CodingTestSetting) {
        let titleSettingViewController = TitleSettingViewController()
        titleSettingViewController.viewModel = TitleSettingViewModel(
            coordinator: self,
            codingTestSettingUseCase: DefaultCodingTestSettinguseCase(
                codingTestSettingRepository: DefaultCodingTestSettingRepository(coreDataService: DefaultCoreDataService.shared),
                codingTestSetting: settingData
            ),
            titleSettingUseCase: DefaultTitleSettingUseCase()
        )
        titleSettingViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(titleSettingViewController, animated: true)
    }
    
    func pushProblemsSettingViewController(with settingData: CodingTestSetting) {
        let problemsSettingViewController = ProblemsSettingViewController()
        problemsSettingViewController.viewModel = ProblemsSettingViewModel(
            coordinator: self,
            codingTestSettingUseCase: DefaultCodingTestSettinguseCase(
                codingTestSettingRepository: DefaultCodingTestSettingRepository(coreDataService: DefaultCoreDataService.shared),
                codingTestSetting: settingData
            )
        )
        
        self.navigationController.pushViewController(problemsSettingViewController, animated: true)
    }
    
    func pushTimeSettingViewController(with settingData: CodingTestSetting) {
        let timeSettingViewController = TimeSettingViewController()
        timeSettingViewController.viewModel = TimeSettingViewModel(
            coordinator: self,
            codingTestSettingUseCase: DefaultCodingTestSettinguseCase(
                codingTestSettingRepository: DefaultCodingTestSettingRepository(coreDataService: DefaultCoreDataService.shared),
                codingTestSetting: settingData
            )
        )
        
        self.navigationController.pushViewController(timeSettingViewController, animated: true)
    }
    
    func pushCodingTestPreparationViewController(with settingData: CodingTestSetting) {
        let codingTestPreparationViewController = CodingTestPreparationViewController()
        codingTestPreparationViewController.viewModel = CodingTestPreparationViewModel(
            coordinator: self,
            codingTestSettingUseCase: DefaultCodingTestSettinguseCase(
                codingTestSettingRepository: DefaultCodingTestSettingRepository(coreDataService: DefaultCoreDataService.shared),
                codingTestSetting: settingData
            )
        )
        
        self.navigationController.pushViewController(codingTestPreparationViewController, animated: true)
    }
}
