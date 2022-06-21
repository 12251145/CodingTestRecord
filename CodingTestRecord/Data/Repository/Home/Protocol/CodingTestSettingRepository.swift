//
//  CodingTestSettingRepository.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import Foundation

protocol CodingTestSettingRepository {
    func loadCodingTestSettings() -> [CodingTestSetting]
    func addCodingTestSetting(_ title: String, _ timeLimit: Int) -> Bool
    func deleteCodingTestSetting(_ codingTestSetting: CodingTestSetting) -> Bool
    func addProblem(at codingTestSetting: CodingTestSetting)
    func deleteProblem(_ problem: Problem, at codingTestSetting: CodingTestSetting)
    func save()
}
