//
//  DefaultCodingTestSettingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Combine
import Foundation
import UserNotifications

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
        let newValue = self.codingTestSetting.value
        newValue.title = text
        
        self.codingTestSettingRepository.save()

        self.codingTestSetting.send(newValue)
    }
    
    func updateTime(with time: Int32) {
        let newValue = self.codingTestSetting.value
        newValue.timeLimit += time
        
        self.codingTestSettingRepository.save()
        
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
    
    func updateProblem(_ problem: Problem, _ difficulty: Int32, _ chekcEfficiency: Bool) {
        problem.difficulty = difficulty
        problem.checkEfficiency = chekcEfficiency
        
        self.codingTestSettingRepository.save()
        
        self.codingTestSetting.send(self.codingTestSetting.value)
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { granted, _ in }
    }
}

