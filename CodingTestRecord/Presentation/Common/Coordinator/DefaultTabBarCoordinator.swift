//
//  DefaultTabBarCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import UIKit

final class DefaultTabBarCoordinator: TabBarCoordinator {
    var tabBarController: UITabBarController
    var finishDelegate: CoordinatorDidFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map({
            self.createNavigationController(of: $0)
        })
        self.configureTabBarController(with: controllers)
    }
    
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: true)
        self.tabBarController.selectedIndex = TabBarPage.home.pageOrderNumber()
        self.tabBarController.tabBar.backgroundColor = .white
        
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
    
    private func createNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = UITabBarItem(
            title: page == .home ? "코딩 테스트" : "기록",
            image: UIImage(systemName: page == .home ? "applescript.fill" : "book.closed.fill"),
            tag: page.pageOrderNumber())
        self.startTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    private func startTabCoordinator(of page: TabBarPage, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            let homeCoordinator = DefaultHomeCoordinator(tabNavigationController)
            homeCoordinator.finishDelegate = self
            self.childCoordinators.append(homeCoordinator)
            homeCoordinator.start()
        case .records:
            let recordsCoordinator = DefaultRecordsCoordinator(tabNavigationController)
            recordsCoordinator.finishDelegate = self
            self.childCoordinators.append(recordsCoordinator)
            recordsCoordinator.start()
        }
    }
}

extension DefaultTabBarCoordinator: CoordinatorDidFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
    }
}
