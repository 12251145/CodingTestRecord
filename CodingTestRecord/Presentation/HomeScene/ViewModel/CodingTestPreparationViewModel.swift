//
//  CodingTestPreparationViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class CodingTestPreparationViewModel {
    weak var coordinator: CodingTestSettingCoordinator?
    private var codingTestSettingUseCase: CodingTestSettingUseCase
    private var codingTestPreparationgUseCase: CodingTestPreparationUseCase
    
    init(
        coordinator: CodingTestSettingCoordinator? = nil,
        codingTestSettingUseCase: CodingTestSettingUseCase,
        codingTestPreparationgUseCase: CodingTestPreparationUseCase
    ) {
        self.coordinator = coordinator
        self.codingTestSettingUseCase = codingTestSettingUseCase
        self.codingTestPreparationgUseCase = codingTestPreparationgUseCase
    }
    
    
    
    struct Input {
        var viewDidLoadEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .sink { _ in
                self.codingTestPreparationgUseCase.executeTimer()
            }
            .store(in: &subscriptions)
        
        self.codingTestPreparationgUseCase.isReady
            .sink { isReady in
                if isReady {
                    let settingData = self.codingTestSettingUseCase.codingTestSetting.value
                    self.coordinator?.finish(with: settingData)
                }
            }
            .store(in: &subscriptions)
        
        return output
    }
}
