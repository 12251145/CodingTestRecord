//
//  CodingTestPreparationViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class CodingTestPreparationViewModel {
    weak var coordinator: CodingTestSettingCoordinator?
    var codingTestSettingUseCase: CodingTestSettingUseCase
    
    init(
        coordinator: CodingTestSettingCoordinator? = nil,
        codingTestSettingUseCase: CodingTestSettingUseCase
    ) {
        self.coordinator = coordinator
        self.codingTestSettingUseCase = codingTestSettingUseCase
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        return output
    }
}
