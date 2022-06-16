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
    private var codingTestSettingUseCase: CodingTestSettingUseCase
    var problems: [Problem] = []
    
    init(coordinator: CodingTestSettingCoordinator? = nil, codingTestSettingUseCase: CodingTestSettingUseCase) {
        self.coordinator = coordinator
        self.codingTestSettingUseCase = codingTestSettingUseCase
    }
    
    struct Input {
        var viewDidLoadEvent: AnyPublisher<Void, Never>
        var addProblemButtonDidTap: AnyPublisher<Void, Never>
        var nextButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var addButtonDidTap = CurrentValueSubject<Bool, Never>(false)
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.addProblemButtonDidTap
            .sink { [weak self] _ in
                self?.codingTestSettingUseCase.addProblem()
                output.addButtonDidTap.send(true)
            }
            .store(in: &subscriptions)
        
        input.nextButtonDidTap
            .sink { [weak self] _ in
                self?.coordinator?.pushTimeSettingViewController(
                    with: self?.codingTestSettingUseCase.codingTestSetting.value ?? CodingTestSetting()
                )
            }
            .store(in: &subscriptions)
        
        self.codingTestSettingUseCase.codingTestSetting
            .sink { codingTestSetting in
                self.problems = codingTestSetting.problemArr
            }
            .store(in: &subscriptions)
        
        return output
    }
}
