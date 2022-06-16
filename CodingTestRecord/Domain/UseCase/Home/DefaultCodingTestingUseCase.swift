//
//  DefaultCodingTestingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class DefaultCodingTestingUseCase: CodingTestingUseCase {
    var codingTesting: CurrentValueSubject<CodingTesting, Never>
    var subscriptions = Set<AnyCancellable>()
    
    init(
        codingTestSetting: CodingTestSetting
    ) {
        let codingTesting = CodingTesting(
            date: Date(),
            title: codingTestSetting.title ?? "타이틀 없음",
            timeLimit: codingTestSetting.timeLimit,
            leftTime: codingTestSetting.timeLimit,
            problems: codingTestSetting.problemArr
        )
        self.codingTesting = CurrentValueSubject<CodingTesting, Never>(codingTesting)
    }
    
    func executeTimer() {
        let start = Date()
        
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .map {
                let newTime = Double(self.codingTesting.value.timeLimit) - $0.timeIntervalSince(start)
                
                return newTime
            }
            .map {
                return Int(round($0))
            }
            .sink { [weak self] leftTime in
                self?.updateTimer(with: leftTime)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Private Functions
private extension DefaultCodingTestingUseCase {
    func updateTimer(with time: Int) {
        var newValue = self.codingTesting.value
        newValue.leftTime = Int32(time)
        
        self.codingTesting.send(newValue)
    }
}
