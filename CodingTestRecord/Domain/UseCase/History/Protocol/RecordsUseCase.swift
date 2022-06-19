//
//  RecordsUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import Foundation

protocol RecordsUseCase {
    var codingTestResults: CurrentValueSubject<[CodingTestResult], Never> { get set }
    func loadCodingTestResults()
}
