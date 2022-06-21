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
        var deleteButtonDidTap: AnyPublisher<Int, Never>
        var viewDidLoadEvent: AnyPublisher<Void, Never>
        var addProblemButtonDidTap: AnyPublisher<Void, Never>
        var updateProblemEvent: AnyPublisher<(Int, Int32, Bool), Never>
        var nextButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var loadData = CurrentValueSubject<Bool, Never>(false)
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.deleteButtonDidTap
            .sink { index in
                self.codingTestSettingUseCase.deleteProblem(self.problems[index])
            }
            .store(in: &subscriptions)
        
        input.addProblemButtonDidTap
            .sink { [weak self] _ in
                self?.codingTestSettingUseCase.addProblem()
            }
            .store(in: &subscriptions)
        
        input.nextButtonDidTap
            .sink { [weak self] _ in
                self?.coordinator?.pushTimeSettingViewController(
                    with: self?.codingTestSettingUseCase.codingTestSetting.value ?? CodingTestSetting()
                )
            }
            .store(in: &subscriptions)
        
        input.updateProblemEvent
            .sink { index, difficulty, checkEfficiency in
                self.codingTestSettingUseCase.updateProblem(self.problems[index], difficulty, checkEfficiency)
            }
            .store(in: &subscriptions)
        
        self.codingTestSettingUseCase.codingTestSetting
            .sink { codingTestSetting in
                self.problems = codingTestSetting.problemArr
                output.loadData.send(true)
            }
            .store(in: &subscriptions)
        
        return output
    }
}

