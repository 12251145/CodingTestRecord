//
//  CodingTestTimelineCellViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

final class CodingTestTimelineCellViewModel {
    weak var delegate: CodingTestTimelineCellDelegate?
    var codingTestTimelineCellUseCase: CodingTestTimelineCellUseCase
    
    init(
        delegate: CodingTestTimelineCellDelegate? = nil,
        codingTestTimelineCellUseCase: CodingTestTimelineCellUseCase
    ) {
        self.delegate = delegate
        self.codingTestTimelineCellUseCase = codingTestTimelineCellUseCase
    }
    
    struct Input {
        
    }
    
    struct Output {
        var passTime = CurrentValueSubject<String, Never>("")
        var takeTime = CurrentValueSubject<String, Never>("")
        var index = CurrentValueSubject<String, Never>("")
        var difficulty = CurrentValueSubject<String, Never>("")
        var passKind = CurrentValueSubject<PassKind, Never>(.accuracy)
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        self.codingTestTimelineCellUseCase.problemEvent
            .map { $0.passTime }
            .map { $0.hhmmss }
            .sink { passTime in
                output.passTime.send(passTime)
            }
            .store(in: &subscriptions)
        
        self.codingTestTimelineCellUseCase.problemEvent
            .map { $0.takeTime }
            .map { $0.mm }
            .sink { takeTime in
                output.takeTime.send(takeTime)
            }
            .store(in: &subscriptions)
        
        self.codingTestTimelineCellUseCase.problemEvent
            .map { $0.index + 1 }
            .map { String($0) }
            .sink { index in
                output.index.send(index)
            }
            .store(in: &subscriptions)
        
        self.codingTestTimelineCellUseCase.problemEvent
            .map { $0.difficulty }
            .map { String($0) }
            .sink { difficulty in
                output.difficulty.send(difficulty)
            }
            .store(in: &subscriptions)
        
        self.codingTestTimelineCellUseCase.problemEvent
            .map { $0.passKind }
            .sink { passKind in
                output.passKind.send(passKind)
            }
            .store(in: &subscriptions)
        
        return output
    }
}
