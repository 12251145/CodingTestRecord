//
//  DefaultCodingTestingCellCuseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

final class DefaultCodingTestingCellUseCase: CodingTestingCellUseCase {
    var index: Int
    var currentState: CurrentValueSubject<Problem, Never>
    
    init(
        index: Int,
        problem: Problem
    ) {
        self.index = index
        self.currentState = CurrentValueSubject<Problem, Never>(problem)
    }
}
