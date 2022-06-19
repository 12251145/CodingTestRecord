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
        var saveButtonDidTap: AnyPublisher<Void, Never>
        var deleteButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var shouldDismiss = CurrentValueSubject<Bool, Never>(false)
        var currentDifficulty = CurrentValueSubject<Int, Never>(0)
        var checkEfficiency = CurrentValueSubject<Bool, Never>(false)
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.switchEvent
            .sink { [weak self] control in
                self?.problemSettingSheetUseCase.updateCheckEfficiency(state: control.isOn)
            }
            .store(in: &subscriptions)
        
        input.difficultyUpButtonDidTap
            .sink { [weak self] _ in
                self?.problemSettingSheetUseCase.upDifficulty()
            }
            .store(in: &subscriptions)
        
        input.difficultyDownButtonDidTap
            .sink { [weak self] _ in
                self?.problemSettingSheetUseCase.downDifficulty()
            }
            .store(in: &subscriptions)
        
        input.saveButtonDidTap
            .sink { [weak self] _ in
                self?.delegate?.updateProblemSetting(difficulty: Int32(self?.problemSettingSheetUseCase.currentDifficulty.value ?? 0),
                                                    checkEfficiency: self?.problemSettingSheetUseCase.currentCheckEfficiency.value ?? false,
                                                    index: self?.problemSettingSheetUseCase.index ?? 0
                )
                output.shouldDismiss.send(true)
            }
            .store(in: &subscriptions)
        
        input.deleteButtonDidTap
            .sink { [weak self] _ in
                self?.delegate?.deleteProblem(index: self?.problemSettingSheetUseCase.index ?? 0)
                output.shouldDismiss.send(true)
            }
            .store(in: &subscriptions)
        
        self.problemSettingSheetUseCase.currentDifficulty
            .sink { newDifficulty in
                output.currentDifficulty.send(newDifficulty)
            }
            .store(in: &subscriptions)
        
        self.problemSettingSheetUseCase.currentCheckEfficiency
            .sink { isOn in
                output.checkEfficiency.send(isOn)
            }
            .store(in: &subscriptions)
            
        
        return output
    }
}
