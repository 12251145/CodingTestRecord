//
//  DefaultCodingTestSettingRepository.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Foundation

final class DefaultCodingTestSettingRepository: CodingTestSettingRepository {
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func loadCodingTestSettings() -> [CodingTestSetting] {
        return self.coreDataService.fetch(request: CodingTestSetting.fetchRequest())
    }
    
    func addCodingTestSetting(_ title: String, _ timeLimit: Int) -> Bool {
        return self.coreDataService.addCodingTestSetting(title, timeLimit)
    }
    
    func addProblem(at codingTestSetting: CodingTestSetting) {
        let problem = self.coreDataService.createProblem()
        
        problem.codingTest = codingTestSetting
    }
    
    func deleteProblem(_ problem: Problem, at codingTestSetting: CodingTestSetting) {
        codingTestSetting.removeFromProblems(problem)
    }
}
