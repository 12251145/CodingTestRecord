//
//  CodingTestResultViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

final class CodingTestResultViewModel {
    weak var coordinator: CodingTestingCoordinator?
    private var codingTestResultUseCase: CodingTestResultUseCase
    var problemEvents: [ProblemEvent] = []
    
    
    init(
        coordinator: CodingTestingCoordinator? = nil,
        codingTestResultUseCase: CodingTestResultUseCase
    ) {
        self.coordinator = coordinator
        self.codingTestResultUseCase = codingTestResultUseCase
    }
    
    

    
    struct Input {
        var viewDidLoadEvent: AnyPublisher<Void, Never>
        var okButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var title = CurrentValueSubject<String, Never>("")
        var score = CurrentValueSubject<Double, Never>(0)
        var total = CurrentValueSubject<Double, Never>(0)
        var loadData = PassthroughSubject<Bool, Never>()
    }
    
    
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .sink { [weak self] _ in
                output.score.send(
                    self?.codingTestResultUseCase.getScore() ?? 0
                )
            }
            .store(in: &subscriptions)
        
        input.okButtonDidTap
            .sink { [weak self] _ in
                
                self?.coordinator?.finish()
            }
            .store(in: &subscriptions)
        
        self.codingTestResultUseCase.codingTestResult
            .compactMap { $0 }
            .map { $0.title ?? "무 타이틀" }
            .sink { title in
                output.title.send(title)
            }
            .store(in: &subscriptions)
        
        self.codingTestResultUseCase.codingTestResult
            .compactMap { $0 }
            .map { Double($0.problemArr.count) }
            .sink { total in
                output.total.send(total)
            }
            .store(in: &subscriptions)
        
        self.codingTestResultUseCase.probelmEvents
            .sink { [weak self] probelmEvents in
                self?.problemEvents = probelmEvents
                output.loadData.send(true)
            }
            .store(in: &subscriptions)
        
        
        
        return output
    }
}
