//
//  TitleSettingViewModelTests.swift
//  CodingTestRecordViewModelTests
//
//  Created by Hoen on 2022/06/28.
//

@testable import CodingTestRecord
import Combine
import XCTest

final class TitleSettingViewModelTests: XCTestCase {
    private var testCoreDataStack: TestCoreDataStack!
    private var viewModel: TitleSettingViewModel!
    private var subscriptions: Set<AnyCancellable>!
    private var input: TitleSettingViewModel.Input!
    private var output: TitleSettingViewModel.Output!

    override func setUpWithError() throws {
        self.testCoreDataStack = TestCoreDataStack()
        // viewModel
        self.subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.subscriptions.removeAll()
    }

    func test_title_text_field() {
        
    }
}
