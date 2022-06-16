//
//  CodingTestingViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class CodingTestingViewModel {
    weak var coordinator: CodingTestingCoordinator?
    private var codingTestSettingUseCase: CodingTestingUseCase
    
    init(
        coordinator: CodingTestingCoordinator? = nil,
        codingTestSettingUseCase: CodingTestingUseCase
    ) {
        self.coordinator = coordinator
        self.codingTestSettingUseCase = codingTestSettingUseCase
    }
    
    struct Input {
        var viewDidLoadEvent: AnyPublisher<Void, Never>
        var cancelButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var leftTime = CurrentValueSubject<Int32, Never>(3600)
        var progress = CurrentValueSubject<Float, Never>(0)
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .sink { _ in
                self.codingTestSettingUseCase.executeTimer()
            }
            .store(in: &subscriptions)
                
        input.cancelButtonDidTap
            .sink { _ in
                self.codingTestSettingUseCase.subscriptions.removeAll()
                self.coordinator?.finish()
            }
            .store(in: &subscriptions)
        
        self.codingTestSettingUseCase.codingTesting
            .map { $0.leftTime }
            .sink { leftTime in
                output.leftTime.send(leftTime)
            }
            .store(in: &subscriptions)
        
        self.codingTestSettingUseCase.codingTesting
            .sink { codingTesting in
                output.progress.send((Float(codingTesting.timeLimit) - Float(codingTesting.leftTime)) / Float(codingTesting.timeLimit))
            }
            .store(in: &subscriptions)
            
        
        return output
    }
}
