//
//  CoordinatorFinishDelegate.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import UIKit

protocol CoordinatorDidFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
