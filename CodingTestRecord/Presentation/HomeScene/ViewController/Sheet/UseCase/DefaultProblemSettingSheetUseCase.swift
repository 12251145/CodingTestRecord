//
//  DefaultProblemSettingSheetUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import Combine
import UIKit
import Foundation

final class DefaultProblemSettingSheetUseCase: ProblemSettingSheetUseCase {
    var currentDifficulty: CurrentValueSubject<Int, Never>
    var currentCheckEfficiency: CurrentValueSubject<Bool, Never>
    
    init(
        currentDifficulty: Int,
        checkEfficiency: Bool
    ) {
        self.currentDifficulty = CurrentValueSubject<Int, Never>(currentDifficulty)
        self.currentCheckEfficiency = CurrentValueSubject<Bool, Never>(checkEfficiency)
    }
    
    func upDifficulty() {
        let current = self.currentDifficulty.value
        var newValue = current
        if current < 5 {
            newValue += 1
        }
        
        self.currentDifficulty.send(newValue)
    }
    
    func downDifficulty() {
        let current = self.currentDifficulty.value
        var newValue = current
        if current > 1 {
            newValue -= 1
        }
        
        self.currentDifficulty.send(newValue)
    }
    
    func updateCheckEfficiency(state: Bool) {
        self.currentCheckEfficiency.send(state)
    }
}
