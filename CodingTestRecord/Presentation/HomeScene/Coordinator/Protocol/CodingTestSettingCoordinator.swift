//
//  CodingTestSettingCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import UIKit

protocol CodingTestSettingCoordinator: Coordinator {
    func pushTitleSettingViewController(with settingData: CodingTestSetting)
    func pushProblemsSettingViewController(with settingData: CodingTestSetting)
    func pushTimeSettingViewController(with settingData: CodingTestSetting)
    func pushCodingTestPreparationViewController(with settingData: CodingTestSetting)
    func finish(with settingData: CodingTestSetting)
}
