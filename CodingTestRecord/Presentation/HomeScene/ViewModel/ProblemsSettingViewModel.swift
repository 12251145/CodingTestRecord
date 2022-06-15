//
//  ProblemsSettingViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation
import UIKit

final class ProblemsSettingViewModel {
    weak var coordinator: CodingTestSettingCoordinator?
    var codingTestSettingUseCase: CodingTestSettingUseCase
    
    init(coordinator: CodingTestSettingCoordinator? = nil, codingTestSettingUseCase: CodingTestSettingUseCase) {
        self.coordinator = coordinator
        self.codingTestSettingUseCase = codingTestSettingUseCase
    }
    
    struct Input {
        var viewDidLoadEvent: AnyPublisher<Void, Never>
        var nextButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.nextButtonDidTap
            .sink { [weak self] _ in
                self?.coordinator?.pushTimeSettingViewController(
                    with: self?.codingTestSettingUseCase.codingTestSetting.value ?? CodingTestSetting()
                )
            }
            .store(in: &subscriptions)
        
        return output
    }
}
