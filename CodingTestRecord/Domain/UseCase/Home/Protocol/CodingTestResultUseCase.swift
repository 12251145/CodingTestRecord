//
//  CodingTestResultUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

protocol CodingTestResultUseCase {
    var codingTestResult: CurrentValueSubject<CodingTestResult?, Never> { get set }
    var probelmEvents: CurrentValueSubject<[ProblemEvent], Never> { get set }
    func getScore() -> Double
}
