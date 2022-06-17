//
//  ProblemSettingSheetUseCase.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import Combine
import UIKit

protocol ProblemSettingSheetUseCase {
    var currentDifficulty: CurrentValueSubject<Int, Never> { get set }
    
    func upDifficulty()
    func downDifficulty()
    func updateCheckEfficiency(state: Bool)
}
