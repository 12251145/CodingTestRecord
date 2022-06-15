//
//  CodingTestingViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

final class CodingTestingViewModel {
    weak var coordinator: CodingTestingCoordinator?
    var codingTestSettingUseCase: CodingTestingUseCase
    
    init(
        coordinator: CodingTestingCoordinator? = nil,
        codingTestSettingUseCase: CodingTestingUseCase
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
