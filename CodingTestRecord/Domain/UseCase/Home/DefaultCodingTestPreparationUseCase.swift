//
//  DefaultCodingTestPreparation.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/16.
//

import Combine
import Foundation

final class DefaultCodingTestPreparationUseCase: CodingTestPreparationUseCase {
    var isReady = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()
    private let maxTime = 2
    
    
    func executeTimer() {
        let start = Date()
        
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .map { output in
                return output.timeIntervalSince(start)
            }
            .map { output in
                return Int(round(output))
            }
            .sink { [weak self] time in
                self?.updateTimer(with: time)
            }
            .store(in: &subscriptions)
        
    }
}

private extension DefaultCodingTestPreparationUseCase {
    func updateTimer(with time: Int) {
        if time >= maxTime {
            subscriptions.removeAll()
            self.isReady.send(true)
        }
    }
}
