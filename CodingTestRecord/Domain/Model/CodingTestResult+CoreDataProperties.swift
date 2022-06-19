//
//  CodingTestResult+CoreDataProperties.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/18.
//
//

import Foundation
import CoreData


extension CodingTestResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CodingTestResult> {
        return NSFetchRequest<CodingTestResult>(entityName: "CodingTestResult")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var timeLimit: Int32
    @NSManaged public var title: String?
    @NSManaged public var problems: NSSet?
    
    public var problemArr: [Problem] {
        let set = problems as? Set<Problem> ?? []
        
        return set.sorted {
            $0.index < $1.index
        }
    }
}

// MARK: Generated accessors for problems
extension CodingTestResult {

    @objc(addProblemsObject:)
    @NSManaged public func addToProblems(_ value: Problem)

    @objc(removeProblemsObject:)
    @NSManaged public func removeFromProblems(_ value: Problem)

    @objc(addProblems:)
    @NSManaged public func addToProblems(_ values: NSSet)

    @objc(removeProblems:)
    @NSManaged public func removeFromProblems(_ values: NSSet)

}

extension CodingTestResult : Identifiable {

}
