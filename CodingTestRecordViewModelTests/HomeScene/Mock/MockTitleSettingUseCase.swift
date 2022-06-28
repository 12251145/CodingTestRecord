//
//  MockTitleSettingUseCase.swift
//  CodingTestRecordViewModelTests
//
//  Created by Hoen on 2022/06/28.
//

@testable import CodingTestRecord
import Combine
import Foundation

final class MockTitleSettingUseCase: TitleSettingUseCase {
    var validatedText = CurrentValueSubject<String?, Never>("")
    
    func validate(text: String) {
        
    }
}
