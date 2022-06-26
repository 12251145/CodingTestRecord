//
//  MockCodingTestSettingUseCase.swift
//  CodingTestRecordViewModelTests
//
//  Created by Hoen on 2022/06/26.
//

@testable import CodingTestRecord
import Combine
import Foundation

final class MockCodingTestSettinguseCase: CodingTestSettingUseCase {
    var codingTestSetting: CurrentValueSubject<CodingTestSetting, Never>
    
    init(
        codingTestSetting: CodingTestSetting
    ) {
        self.codingTestSetting = CurrentValueSubject<CodingTestSetting, Never>(codingTestSetting)
    }

    
    func updateTitle(with text: String) {
        let newValue = self.codingTestSetting.value
        newValue.title = text

        self.codingTestSetting.send(newValue)
    }
    
    func updateTime(with time: Int32) {        
        let newValue = self.codingTestSetting.value
        newValue.timeLimit += time

        self.codingTestSetting.send(newValue)
    }
    
    func addProblem() {}
    
    func deleteProblem(_ problem: Problem) {}
    
    func updateProblem(_ problem: Problem, _ difficulty: Int32, _ chekcEfficiency: Bool) {}
    
    func requestNotificationAuthorization() {}
}
