//
//  CodingTestingUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//

import Combine
import Foundation

protocol CodingTestingUseCase {
    var isTimeOver: CurrentValueSubject<Bool, Never> { get set }
    var codingTesting: CurrentValueSubject<CodingTesting, Never> { get set }
    var subscriptions: Set<AnyCancellable> { get set }
    
    func executeTimer()
    func updateCodintTesting(index: Int, passKind: PassKind, isPass: Bool)
}
