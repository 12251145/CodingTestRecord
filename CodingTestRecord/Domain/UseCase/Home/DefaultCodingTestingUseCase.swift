//
//  DefaultCodingTestingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class DefaultCodingTestingUseCase: CodingTestingUseCase {
    var isTimeOver = CurrentValueSubject<Bool, Never>(false)
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
    
    func updateCodintTesting(index: Int, passKind: PassKind, isPass: Bool) {
        let newValue = self.codingTesting.value
        if passKind == .accuracy {
            newValue.problems[index].passAccuracyTest = isPass
            newValue.problems[index].accuracyTestPassTime = isPass ? (self.codingTesting.value.timeLimit - self.codingTesting.value.leftTime) : 0
        } else {
            newValue.problems[index].passEfficiencyTest = isPass
            newValue.problems[index].efficiencyTestPassTime = isPass ? (self.codingTesting.value.timeLimit - self.codingTesting.value.leftTime) : 0
        }
        
        self.codingTesting.send(newValue)
    }
}

// MARK: - Private Functions
private extension DefaultCodingTestingUseCase {
    func updateTimer(with time: Int) {
        if time <= 0 {
            self.subscriptions.removeAll()
            self.isTimeOver.send(true)
        }
        
        var newValue = self.codingTesting.value
        newValue.leftTime = Int32(time)
        
        self.codingTesting.send(newValue)
    }
}
