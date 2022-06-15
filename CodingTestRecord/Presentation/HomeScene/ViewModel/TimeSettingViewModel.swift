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
        var doneButtonDidTap: AnyPublisher<Void, Never>
        var startButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.doneButtonDidTap
            .sink { _ in
                self.coordinator?.finish()
            }
            .store(in: &subscriptions)
        
        input.startButtonDidTap
            .sink { _ in                
                self.coordinator?.pushCodingTestPreparationViewController(with: self.codingTestSettingUseCase.codingTestSetting.value)
            }.store(in: &subscriptions)
        
        return output
    }
}
