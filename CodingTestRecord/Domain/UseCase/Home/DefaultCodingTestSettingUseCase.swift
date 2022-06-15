//
//  DefaultCodingTestSettingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Combine
import Foundation

final class DefaultCodingTestSettinguseCase: CodingTestSettingUseCase {
    var codingTestSetting: CurrentValueSubject<CodingTestSetting, Never>
    
    init(
        codingTestSetting: CodingTestSetting
    ) {
        self.codingTestSetting = CurrentValueSubject<CodingTestSetting, Never>(codingTestSetting)
    }
    
    func updateTitle(with text: String) {
        self.codingTestSetting.value.title = text
    }
}
