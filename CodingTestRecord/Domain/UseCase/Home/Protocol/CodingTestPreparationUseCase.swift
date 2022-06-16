//
//  CodingTestPreparationUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/16.
//

import Combine
import Foundation

protocol CodingTestPreparationUseCase {
    var isReady: CurrentValueSubject<Bool, Never> { get set }
    func executeTimer()
}
