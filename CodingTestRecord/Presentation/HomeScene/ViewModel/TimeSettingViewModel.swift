//
//  TimeSettingViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class TimeSettingViewModel {
    weak var coordinator: CodingTestSettingCoordinator?
    var codingTestSettingUseCase: CodingTestSettingUseCase
    
    init(coordinator: CodingTestSettingCoordinator? = nil, codingTestSettingUseCase: CodingTestSettingUseCase) {
        self.coordinator = coordinator
        self.codingTestSettingUseCase = codingTestSettingUseCase
    }
    
    struct Input {
        var timePlusButtonDidTap: AnyPublisher<Void, Never>
        var timeSbustractButtonDidTap: AnyPublisher<Void, Never>
        var doneButtonDidTap: AnyPublisher<Void, Never>
        var startButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var timeLimit = CurrentValueSubject<String, Never>("")
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.timePlusButtonDidTap
            .sink { _ in
                self.codingTestSettingUseCase.updateTime(with: 1800)
            }
            .store(in: &subscriptions)
        
        input.timeSbustractButtonDidTap
            .sink { _ in
                self.codingTestSettingUseCase.updateTime(with: -1800)
            }
            .store(in: &subscriptions)
        
        input.doneButtonDidTap
            .sink { _ in
                self.coordinator?.finish()
            }
            .store(in: &subscriptions)
        
        input.startButtonDidTap
            .sink { _ in                
                self.coordinator?.pushCodingTestPreparationViewController(with: self.codingTestSettingUseCase.codingTestSetting.value)
            }.store(in: &subscriptions)
        
        self.codingTestSettingUseCase.codingTestSetting
            .map { $0.timeLimit }
            .sink { newTime in
                print(newTime)
                output.timeLimit.send(newTime.hhmm)
            }
            .store(in: &subscriptions)
        
        return output
    }
}
