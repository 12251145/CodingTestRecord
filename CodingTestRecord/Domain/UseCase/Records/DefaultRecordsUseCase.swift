//
//  DefaultRecordsUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import Foundation

final class DefaultRecordsUseCase: RecordsUseCase {
    private let codingTestResultRepository: CodingTestResultRepository
    
    var codingTestResults: CurrentValueSubject<[CodingTestResult], Never>
    
    init(
        codingTestResultRepository: CodingTestResultRepository
    ) {
        self.codingTestResultRepository = codingTestResultRepository
        self.codingTestResults = CurrentValueSubject<[CodingTestResult], Never>(self.codingTestResultRepository.loadCodingTestResults())
    }
    
    func loadCodingTestResults() {
        self.codingTestResults.send(self.codingTestResultRepository.loadCodingTestResults())
    }
    
    func deleteCodingTestSetting(_ codingTestResult: CodingTestResult) {
        if self.codingTestResultRepository.deleteCodingTestResult(codingTestResult) {
            let newValue = self.codingTestResultRepository.loadCodingTestResults()
            self.codingTestResults.send(newValue)
        }
    }
}






