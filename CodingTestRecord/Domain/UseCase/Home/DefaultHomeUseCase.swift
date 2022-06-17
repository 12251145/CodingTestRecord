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
        if self.codingTestSettingRepository.addCodingTestSetting("노란회사 인턴", 18000) {
            
            self.loadCodingTestSettings()
        }
    }
    
    func loadCodingTestSettings() {
//        self.codingTests.value = self.sortedCodintTestSettings(
//            list: self.codingTestSettingRepository.loadCodingTestSettings()
//        )
        
        let newValue = self.sortedCodintTestSettings(
            list: self.codingTestSettingRepository.loadCodingTestSettings()
        )
        
        
        self.codingTests.send(newValue)
    }
    
    func sortedCodintTestSettings(list: [CodingTestSetting]) -> [CodingTestSetting] {
        return list.sorted { $0.date! < $1.date! }
    }
}
