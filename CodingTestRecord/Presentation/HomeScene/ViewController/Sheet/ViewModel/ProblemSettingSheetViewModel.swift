//
//  ProblemSettingSheetViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import Combine
import Foundation
import UIKit

final class ProblemSettingSheetViewModel {
    var delegate: ProblemSettingSheetDelegate?
    var problemSettingSheetUseCase: ProblemSettingSheetUseCase
    
    init(
        delegate: ProblemSettingSheetDelegate? = nil,
        problemSettingSheetUseCase: ProblemSettingSheetUseCase
    ) {
        self.delegate = delegate
        self.problemSettingSheetUseCase = problemSettingSheetUseCase
    }
    
    struct Input {
        var switchEvent: AnyPublisher<UISwitch, Never>
        var difficultyUpButtonDidTap: AnyPublisher<Void, Never>
        var difficultyDownButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var currentDifficulty = CurrentValueSubject<Int, Never>(0)
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.switchEvent
            .sink { control in
                self.problemSettingSheetUseCase.updateCheckEfficiency(state: control.isOn)
            }
            .store(in: &subscriptions)
        
        input.difficultyUpButtonDidTap
            .sink { _ in
                self.problemSettingSheetUseCase.upDifficulty()
            }
            .store(in: &subscriptions)
        
        input.difficultyDownButtonDidTap
            .sink { _ in
                self.problemSettingSheetUseCase.downDifficulty()
            }
            .store(in: &subscriptions)
        
        self.problemSettingSheetUseCase.currentDifficulty
            .sink { newDifficulty in
                output.currentDifficulty.send(newDifficulty)
            }
            .store(in: &subscriptions)
            
        
        return output
    }
}
