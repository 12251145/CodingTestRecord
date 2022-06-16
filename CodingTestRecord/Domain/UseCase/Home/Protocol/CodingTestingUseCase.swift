//
//  CodingTestingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

protocol CodingTestingUseCase {
    var codingTesting: CurrentValueSubject<CodingTesting, Never> { get set }
    var subscriptions: Set<AnyCancellable> { get set }
    
    func executeTimer()
}
