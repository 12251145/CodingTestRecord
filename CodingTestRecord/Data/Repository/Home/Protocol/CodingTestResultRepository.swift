//
//  CodingTestResultRepository.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//

import Foundation

protocol CodingTestResultRepository {
    func getCodingTestResult(by codingTesting: CodingTesting) -> CodingTestResult?
}
