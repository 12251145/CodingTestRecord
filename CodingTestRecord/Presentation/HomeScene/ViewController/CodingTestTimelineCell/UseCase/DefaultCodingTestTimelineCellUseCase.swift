//
//  DefaultCodingTestTimelineCellUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

final class DefaultCodingTestTimelineCellUseCase: CodingTestTimelineCellUseCase {
    var index: Int
    var problemEvent: CurrentValueSubject<ProblemEvent, Never>
    
    init(
        index: Int,
        problemEvent: ProblemEvent
    ) {
        self.index = index
        self.problemEvent = CurrentValueSubject<ProblemEvent, Never>(problemEvent)
    }
}
