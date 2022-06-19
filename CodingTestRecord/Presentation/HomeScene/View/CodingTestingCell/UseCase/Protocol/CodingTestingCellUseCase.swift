//
//  CodingTestingCellUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Combine
import Foundation

protocol CodingTestingCellUseCase {
    var index: Int { get }
    
    var currentState: CurrentValueSubject<Problem, Never> { get set }
}

