//
//  ProblemSettingSheetDelegate.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/17.
//

import Foundation

protocol ProblemSettingSheetDelegate {
    func updateProblemSetting(difficulty: Int32, checkEfficiency: Bool, index: Int)
    func deleteProblem(index: Int)
    func reloadTableView()
}
