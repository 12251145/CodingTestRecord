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
    var codingTestSettings: [CodingTestSetting] = []
    
    init(coordinator: HomeCoordinator, homeUseCase: HomeUseCase) {
        self.coordinator = coordinator
        self.homeUseCase = homeUseCase
    }
    
    struct Input {
        let viewDidLoadEvent: AnyPublisher<Void, Never>
        let addCodingTestButtonDidTap: AnyPublisher<Void, Never>
        let tableViewCellDidSelected: AnyPublisher<Int, Never>
    }
    
    struct Output {
        var addButtonDidTap = PassthroughSubject<Bool, Never>()
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
                output.addButtonDidTap.send(true)
            }
            .store(in: &subscriptions)
        
        input.tableViewCellDidSelected
            .sink { [weak self] indexPathRow in
                self?.coordinator?.showSettingFlow(with: self?.codingTestSettings[indexPathRow] ?? CodingTestSetting()) 
            }
            .store(in: &subscriptions)
        
        self.homeUseCase.codingTests
            .sink { codingTestSettings in                
                self.codingTestSettings = codingTestSettings
            }
            .store(in: &subscriptions)
        
        return output
    }
}
