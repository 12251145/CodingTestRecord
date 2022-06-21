//
//  HomeUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import Combine
import Foundation

protocol HomeUseCase {
    var codingTests: CurrentValueSubject<[CodingTestSetting], Never> { get set }
    
    func loadCodingTestSettings()
    func addCodingTest()    
}
