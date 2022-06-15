//
//  TitleSettingViewModel.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Combine
import Foundation
import UIKit

final class TitleSettingViewModel {
    weak var coordinator: CodingTestSettingCoordinator?
    var codingTestSettingUseCase: CodingTestSettingUseCase
    var titleSettingUseCase: TitleSettingUseCase
    
    init(
        coordinator: CodingTestSettingCoordinator? = nil,
        codingTestSettingUseCase: CodingTestSettingUseCase,
        titleSettingUseCase: TitleSettingUseCase
    ) {
        self.coordinator = coordinator
        self.codingTestSettingUseCase = codingTestSettingUseCase
        self.titleSettingUseCase = titleSettingUseCase
    }
    
    struct Input {
        var viewDidLoadEvent: AnyPublisher<Void, Never>
        var titleTextField: AnyPublisher<UITextField, Never>
        var nextButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var titleTextField = CurrentValueSubject<String, Never>("...")
    }
    
    func transform(from input: Input, subscriptions: inout Set<AnyCancellable>) -> Output {
        let output = Output()
        
        input.viewDidLoadEvent
            .sink { [weak self] _ in
                self?.titleSettingUseCase.validate(
                    text: self?.codingTestSettingUseCase.codingTestSetting.value.title ?? "..."
                )
            }
            .store(in: &subscriptions)
        
        input.titleTextField
            .sink { [weak self] control in
                self?.titleSettingUseCase.validate(text: control.text ?? "...")
            }
            .store(in: &subscriptions)
        
        input.nextButtonDidTap
            .sink { [weak self] _ in
                self?.coordinator?.pushProblemsSettingViewController(
                    with: self?.codingTestSettingUseCase.codingTestSetting.value ?? CodingTestSetting()
                )
            }
            .store(in: &subscriptions)
        
        self.titleSettingUseCase.validatedText
            .scan("") { return $1 == nil ? $0 : $1 }
            .compactMap({$0})
            .sink { newText in
                output.titleTextField.send(newText)
                self.codingTestSettingUseCase.updateTitle(with: newText)
            }
            .store(in: &subscriptions)
            
            
        
        return output
    }
}
