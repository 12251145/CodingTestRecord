//
//  CoreDataService.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//

import CoreData
import Foundation

protocol CoreDataService {
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]
    func addCodingTestSetting(_ title: String, _ timeLimit: Int) -> Bool
}
