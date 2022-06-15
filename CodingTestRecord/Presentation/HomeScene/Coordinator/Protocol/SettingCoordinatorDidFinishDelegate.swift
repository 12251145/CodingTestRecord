//
//  SettingCoordinatorDidFinishDelegate.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Foundation

protocol SettingCoordinatorDidFinishDelegate: AnyObject {
    func settingCoordinatorDidFinish(with settingData: CodingTestSetting)
}
