//
//  TimeSettingViewModelTests.swift
//  CodingTestRecordViewModelTests
//
//  Created by Hoen on 2022/06/26.
//

@testable import CodingTestRecord
import Combine
import XCTest

final class TimeSettingViewModelTests: XCTestCase {
    private var testCoreDataStack: TestCoreDataStack!
    private var viewModel: TimeSettingViewModel!
    private var subscriptions: Set<AnyCancellable>!
    private var input: TimeSettingViewModel.Input!
    private var output: TimeSettingViewModel.Output!

    override func setUpWithError() throws {
        self.testCoreDataStack = TestCoreDataStack()
        self.viewModel = TimeSettingViewModel(
            codingTestSettingUseCase: MockCodingTestSettinguseCase(
                codingTestSetting: testCoreDataStack.createDummyCodingTestSetting()
            )
        )
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.subscriptions.removeAll()
    }

    func test_plus_and_substract_button_tap() {
        let plusButtonTapEvent = Future<Void, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                promise(.success(()))
            }
        }
        
        let substractButtonTapEvent = Future<Void, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                promise(.success(()))
            }
        }
        
        self.input = TimeSettingViewModel.Input(
            viewDidLoadEvent: Just(()).eraseToAnyPublisher(),
            timePlusButtonDidTap: plusButtonTapEvent.eraseToAnyPublisher(),
            timeSbustractButtonDidTap: substractButtonTapEvent.eraseToAnyPublisher(),
            doneButtonDidTap: Just(()).eraseToAnyPublisher(),
            startButtonDidTap: Just(()).eraseToAnyPublisher()
        )
        
        let expectation = XCTestExpectation(description: "Test done asynchronously.")
        
        let output = self.viewModel.transform(from: self.input, subscriptions: &subscriptions)
            
        output.timeLimit
            .collect()
            .sink { events in
                XCTAssertEqual(events, ["3?????? 00???", "3?????? 30???", "3?????? 00???"])
                
                expectation.fulfill()
            }
            .store(in: &subscriptions)
               
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            output.timeLimit.send(completion: .finished)
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
