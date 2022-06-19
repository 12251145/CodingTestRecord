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
    private var codingTestingUseCase: CodingTestingUseCase
    var problems: [Problem] = []
    
    init(
        coordinator: CodingTestingCoordinator? = nil,
        codingTestSettingUseCase: CodingTestingUseCase
    ) {
        self.coordinator = coordinator
        self.codingTestingUseCase = codingTestSettingUseCase
    }
    
    struct Input {
        var passUpdateEvent: AnyPublisher<(Int, PassKind, Bool), Never>
        var viewDidLoadEvent: AnyPublisher<Void, Never>
        var cancelButtonDidTap: AnyPublisher<Void, Never>
        var endButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var title = CurrentValueSubject<String, Never>("")
        var leftTime = CurrentValueSubject<Int32, Never>(3600)
        var progress = CurrentValueSubject<Float, Never>(0)
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.passUpdateEvent
            .sink { index, passKind, isPass in
                self.codingTestingUseCase.updateCodintTesting(index: index, passKind: passKind, isPass: isPass)                
            }
            .store(in: &subscriptions)
        
        input.viewDidLoadEvent
            .sink { _ in
                self.codingTestingUseCase.executeTimer()
            }
            .store(in: &subscriptions)
                
        input.cancelButtonDidTap
            .sink { _ in
                self.codingTestingUseCase.subscriptions.removeAll()
                self.coordinator?.finish()
            }
            .store(in: &subscriptions)
        
        input.endButtonDidTap
            .sink { _ in
                self.coordinator?.pushCodingTestResultViewController(with: self.codingTestingUseCase.codingTesting.value)
            }
            .store(in: &subscriptions)
        
        self.codingTestingUseCase.codingTesting
            .map { $0.title }
            .sink { title in
                output.title.send(title)
            }
            .store(in: &subscriptions)
        
        self.codingTestingUseCase.codingTesting
            .map { $0.leftTime }
            .sink { leftTime in
                output.leftTime.send(leftTime)
            }
            .store(in: &subscriptions)
        
        self.codingTestingUseCase.codingTesting
            .sink { codingTesting in
                output.progress.send((Float(codingTesting.timeLimit) - Float(codingTesting.leftTime)) / Float(codingTesting.timeLimit))
                self.problems = codingTesting.problems
            }
            .store(in: &subscriptions)
            
        self.codingTestingUseCase.isTimeOver
            .filter{ $0 }
            .sink { _ in
                self.coordinator?.pushCodingTestResultViewController(with: self.codingTestingUseCase.codingTesting.value)
            }
            .store(in: &subscriptions)
        
        return output
    }
}
