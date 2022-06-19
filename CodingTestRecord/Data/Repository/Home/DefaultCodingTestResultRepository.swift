//
//  DefaultCodingTestResultRepository.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Foundation

final class DefaultCodingTestResultRepository: CodingTestResultRepository {
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func loadCodingTestResults() -> [CodingTestResult] {
        return self.coreDataService.fetch(request: CodingTestResult.fetchRequest())
    }
    
    func getCodingTestResult(by codingTesting: CodingTesting) -> CodingTestResult? {
        return self.coreDataService.createCodingTestResult(by: codingTesting)
    }
    
    func getCodingTesting(by codingTestSetting: CodingTestSetting) -> CodingTesting {
        return self.coreDataService.createCodingTesting(by: codingTestSetting)
    }
}
