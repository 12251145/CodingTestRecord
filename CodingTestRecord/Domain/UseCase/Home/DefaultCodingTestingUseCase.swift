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
}
