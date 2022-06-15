//
//  TitleSettingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

protocol TitleSettingUseCase {
    var validatedText: CurrentValueSubject<String?, Never> { get set }
    
    func validate(text: String)
}
