//
//  CodingTestSettingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Combine
import Foundation

protocol CodingTestSettingUseCase {
    var codingTestSetting: CurrentValueSubject<CodingTestSetting, Never> { get set }
    func updateTitle(with text: String)
}
