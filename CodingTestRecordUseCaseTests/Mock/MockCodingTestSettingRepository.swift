//
//  MockCodingTestSettingRepository.swift
//  CodingTestRecordUseCaseTests
//
//  Created by Hoen on 2022/06/27.
//

@testable import CodingTestRecord
import Foundation

final class MockCodingTestSettingRepository: CodingTestSettingRepository {
    private let testCoreDataStack: TestCoreDataStack
    
    init(testCoreDataStack: TestCoreDataStack) {
        self.testCoreDataStack = testCoreDataStack
    }
    
    func loadCodingTestSettings() -> [CodingTestRecord.CodingTestSetting] {
        return self.testCoreDataStack.fetch(request: CodingTestSetting.fetchRequest())
    }
    
    func addCodingTestSetting(_ title: String, _ timeLimit: Int) -> Bool {
        return false
    }
    
    func deleteCodingTestSetting(_ codingTestSetting: CodingTestRecord.CodingTestSetting) -> Bool {
        return false
    }
    
    func addProblem(at codingTestSetting: CodingTestRecord.CodingTestSetting) {
        let problem = self.testCoreDataStack.createProblem()
        
        problem.codingTest = codingTestSetting
    }
    
    func deleteProblem(_ problem: CodingTestRecord.Problem, at codingTestSetting: CodingTestRecord.CodingTestSetting) {
        codingTestSetting.removeFromProblems(problem)
    }
    
    func save() { }
}
