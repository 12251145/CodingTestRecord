//
//  DefaultHomeUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import Foundation

final class DefaultHomeUseCase: HomeUseCase {
    private let codingTestSettingRepository: CodingTestSettingRepository
    
    var codingTests: CurrentValueSubject<[CodingTestSetting], Never>
    
    init(
        codingTestSettingRepository: CodingTestSettingRepository
    ) {
        self.codingTestSettingRepository = codingTestSettingRepository
        self.codingTests = CurrentValueSubject<[CodingTestSetting], Never>([])
    }
    
    func addCodingTest() {
        if self.codingTestSettingRepository.addCodingTestSetting("테스트", 3600) {
            self.loadCodingTestSettings()
        }
    }
    
    func loadCodingTestSettings() {
        codingTests.value = self.codingTestSettingRepository.loadCodingTestSettings()
    }
}
