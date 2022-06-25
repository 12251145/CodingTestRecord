//
//  DefaultCodingTestingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation
import UserNotifications

final class DefaultCodingTestingUseCase: CodingTestingUseCase {
    private let codingTestResultRepository: CodingTestResultRepository
    var isTimeOver = CurrentValueSubject<Bool, Never>(false)
    var codingTesting: CurrentValueSubject<CodingTesting, Never>
    var subscriptions = Set<AnyCancellable>()
    
    init(
        codingTestResultRepository: CodingTestResultRepository,
        codingTestSetting: CodingTestSetting
    ) {
        self.codingTestResultRepository = codingTestResultRepository
        
        let codingTesting = self.codingTestResultRepository.getCodingTesting(by: codingTestSetting)
        self.codingTesting = CurrentValueSubject<CodingTesting, Never>(codingTesting)
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "테스트가 종료되었습니다"
        
        let date = Date(timeIntervalSinceNow: TimeInterval(self.codingTesting.value.timeLimit))
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: calendarTrigger)
        
        UNUserNotificationCenter.current().add(request)
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
