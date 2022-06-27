//
//  CodingTestRecordUseCaseTests.swift
//  CodingTestRecordUseCaseTests
//
//  Created by Hoen on 2022/06/27.
//

@testable import CodingTestRecord
import Combine
import XCTest

final class CodingTestSettingUseCaseTests: XCTestCase {
    var testCoreDataStack: TestCoreDataStack!
    var useCase: CodingTestSettingUseCase?
    var subscriptions: Set<AnyCancellable>!

    override func setUpWithError() throws {
        self.testCoreDataStack = TestCoreDataStack()
        self.useCase = DefaultCodingTestSettinguseCase(
            codingTestSettingRepository: MockCodingTestSettingRepository(testCoreDataStack: testCoreDataStack),
            codingTestSetting: testCoreDataStack.createDummyCodingTestSetting()
        )
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        self.useCase = nil
        self.subscriptions.removeAll()
    }

    func test_update_title() throws {
        let expectation = XCTestExpectation(description: "Test done asynchronously.")
        
        self.useCase?.codingTestSetting
            .dropFirst()
            .map { $0.title }
            .sink(receiveValue: { title in
                XCTAssertEqual(title, "Test")
                
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        
        self.useCase?.updateTitle(with: "Test")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_update_time_with_1800() throws {
        let expectation = XCTestExpectation(description: "Test done asynchronously.")
        
        let before = self.useCase?.codingTestSetting.value.timeLimit ?? 0
        let addAmount: Int32 = 1800
        
        self.useCase?.codingTestSetting
            .dropFirst()
            .map { $0.timeLimit }
            .sink(receiveValue: { timeLimit in
                XCTAssertEqual(timeLimit, before + addAmount)
                
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        
        self.useCase?.updateTime(with: addAmount)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_update_time_upper_limit() throws {
        let expectation = XCTestExpectation(description: "Test done asynchronously.")
                
        let addAmount: Int32 = 43200
        
        self.useCase?.codingTestSetting
            .dropFirst()
            .map { $0.timeLimit }
            .sink(receiveValue: { timeLimit in
                XCTAssertEqual(timeLimit, 43200)
                
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        
        self.useCase?.updateTime(with: addAmount)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_update_time_lower_limit() throws {
        let expectation = XCTestExpectation(description: "Test done asynchronously.")
                
        let addAmount: Int32 = -43200
        
        self.useCase?.codingTestSetting
            .dropFirst()
            .map { $0.timeLimit }
            .sink(receiveValue: { timeLimit in
                XCTAssertEqual(timeLimit, 0)
                
                expectation.fulfill()
            })
            .store(in: &subscriptions)
        
        self.useCase?.updateTime(with: addAmount)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_add_problem() throws {
        let before = try XCTUnwrap(self.useCase?.codingTestSetting.value.problems?.count)
            
        self.useCase?.addProblem()
        
        let after = try XCTUnwrap(self.useCase?.codingTestSetting.value.problems?.count)
        
        XCTAssertEqual(before + 1, after)
    }
    
    func test_delete_problem() throws {
        self.useCase?.addProblem()
        
        let before = try XCTUnwrap(self.useCase?.codingTestSetting.value.problems?.count)
        
        let problem = try XCTUnwrap(self.useCase?.codingTestSetting.value.problemArr.last)
        
        self.useCase?.deleteProblem(problem)
        
        let after = try XCTUnwrap(self.useCase?.codingTestSetting.value.problems?.count)
        
        XCTAssertEqual(before - 1, after)
    }
    
    func test_update_problem() throws {
        self.useCase?.addProblem()
        
        let problem = try XCTUnwrap(self.useCase?.codingTestSetting.value.problemArr.last)
        
        self.useCase?.updateProblem(problem, 1, true)
        
        XCTAssertEqual(problem.difficulty, 1)
        XCTAssertEqual(problem.checkEfficiency, true)
        
        self.useCase?.updateProblem(problem, 5, false)
        
        XCTAssertEqual(problem.difficulty, 5)
        XCTAssertEqual(problem.checkEfficiency, false)
    }
}
