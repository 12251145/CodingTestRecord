//
//  CodingTestingCellViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import UIKit

final class CodingTestingCellViewModel {
    var delegate: CodingTestingCellDelegate?
    var codingTesingCellUseCase: CodingTestingCellUseCase
    
    init(
        delegate: CodingTestingCellDelegate? = nil,
        codingTesingCellUseCase: CodingTestingCellUseCase
    ) {
        self.delegate = delegate
        self.codingTesingCellUseCase = codingTesingCellUseCase
    }
    
    struct Input {
        var passAccuracySwitchEvent: AnyPublisher<UISwitch, Never>
        var passEfficiencySwitchEvent: AnyPublisher<UISwitch, Never>
    }
    
    struct Output {
        var showEfficiencySwitch = CurrentValueSubject<Bool, Never>(false)        
        var currentDifficulty = CurrentValueSubject<Int, Never>(0)
    }
    
    func transform(from input: Input, subscruptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.passAccuracySwitchEvent
            .sink { control in
                self.delegate?.updatePassState(index: self.codingTesingCellUseCase.index, kind: PassKind.accuracy, isPass: control.isOn)
            }
            .store(in: &subscruptions)
        
        input.passEfficiencySwitchEvent
            .sink { control in
                self.delegate?.updatePassState(index: self.codingTesingCellUseCase.index, kind: PassKind.efficiency, isPass: control.isOn)
            }
            .store(in: &subscruptions)
        
        self.codingTesingCellUseCase.currentState
            .map { $0.difficulty }
            .sink { difficulty in                
                output.currentDifficulty.send(Int(difficulty))
            }
            .store(in: &subscruptions)
        
        self.codingTesingCellUseCase.currentState
            .map { $0.checkEfficiency }
            .sink { shouldShow in
                output.showEfficiencySwitch.send(shouldShow)
            }
            .store(in: &subscruptions)

        
        return output
    }
}
