//
//  DefaultTitleSettingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class DefaultTitleSettingUseCase: TitleSettingUseCase {
    var validatedText = CurrentValueSubject<String?, Never>("...")
    
    func validate(text: String) {
        self.validatedText.send(self.checkValidity(of: text))
    }
    
    private func checkValidity(of titleText: String) -> String? {
        let checkText = String(titleText.prefix(20))
        guard checkText.count <= 20 else { return nil }
        return checkText
    }
}
