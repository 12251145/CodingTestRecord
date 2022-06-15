//
//  HomeCoordinator.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import UIKit

protocol HomeCoordinator: Coordinator {
    func showSettingFlow(with settingData: CodingTestSetting)
}
