//
//  CodingTestingCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Foundation

protocol CodingTestingCoordinator: Coordinator {
    func pushCodingTestingViewController(with settingData: CodingTestSetting)
    func pushCodingTestResultViewController(with result: CodingTesting)
}
