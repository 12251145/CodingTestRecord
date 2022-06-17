//
//  ProblemSettingSheetUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import Combine
import UIKit

protocol ProblemSettingSheetUseCase {
    var index: Int { get }
    var currentDifficulty: CurrentValueSubject<Int, Never> { get set }
    var currentCheckEfficiency: CurrentValueSubject<Bool, Never> { get set }
    
    func upDifficulty()
    func downDifficulty()
    func updateCheckEfficiency(state: Bool)
}
