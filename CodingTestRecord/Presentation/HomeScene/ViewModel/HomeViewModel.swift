//
//  HomeViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import UIKit

final class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    private var homeUseCase: HomeUseCase
    
    init(coordinator: HomeCoordinator, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: AnyPublisher<Void, Never>
        let addCodingTestButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var codingTestSettings = CurrentValueSubject<[CodingTestSetting], Never>([])
    }
    
    func transform(input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .sink { _ in
                
            }
            .store(in: &subscriptions)
        
        input.addCodingTestButtonDidTap
            .sink { _ in
                self.homeUseCase.addCodingTest()
            }
            .store(in: &subscriptions)
        
        self.homeUseCase.codingTests
            .sink { codingTestSettings in
                output.codingTestSettings.value = codingTestSettings
            }
            .store(in: &subscriptions)
        
        return output
    }
}
