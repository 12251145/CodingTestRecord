//
//  CodingTestTimelineCellUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

protocol CodingTestTimelineCellUseCase {
    var index: Int { get }
    var problemEvent: CurrentValueSubject<ProblemEvent, Never> { get set }
}
