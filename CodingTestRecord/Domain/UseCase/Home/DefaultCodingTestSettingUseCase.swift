//
//  DefaultCodingTestSettingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Combine
import Foundation

final class DefaultCodingTestSettinguseCase: CodingTestSettingUseCase {
    private let codingTestSettingRepository: CodingTestSettingRepository
    
    var codingTestSetting: CurrentValueSubject<CodingTestSetting, Never>
    
    init(
        codingTestSettingRepository: CodingTestSettingRepository,
        codingTestSetting: CodingTestSetting
    ) {
        self.codingTestSettingRepository = codingTestSettingRepository
        self.codingTestSetting = CurrentValueSubject<CodingTestSetting, Never>(codingTestSetting)
    }
    
    func updateTitle(with text: String) {
//        let newValue = self.codingTestSetting.value
//        newValue.title = text
//
//        self.codingTestSetting.send(newValue)
        
        self.codingTestSetting.value.title = text
    }
    
    func updateTime(with time: Int32) {
        let newValue = self.codingTestSetting.value
        newValue.timeLimit += time
        
        self.codingTestSetting.send(newValue)
    }
    
    func addProblem() {
        self.codingTestSettingRepository.addProblem(at: self.codingTestSetting.value)
        
        self.codingTestSetting.send(self.codingTestSetting.value)
    }
    
    func deleteProblem(_ problem: Problem) {
        self.codingTestSettingRepository.deleteProblem(problem, at: self.codingTestSetting.value)
        
        self.codingTestSetting.send(self.codingTestSetting.value)
    }
}
