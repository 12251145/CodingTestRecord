//
//  CoreDataService.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import CoreData
import Foundation

protocol CoreDataService {
//    static var shared: DefaultCoreDataService { get set }
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
    func addCodingTestSetting(_ title: String, _ timeLimit: Int) -> Bool
    func delete(object: NSManagedObject) -> Bool
    func save() -> Bool
    func createProblem() -> Problem
    func createCodingTesting(by codingTestSetting: CodingTestSetting) -> CodingTesting
    func createCodingTestResult(by codingTesting: CodingTesting) -> CodingTestResult?
}
