//
//  CodingTestSetting+CoreDataProperties.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//
//

import Foundation
import CoreData


extension CodingTestSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CodingTestSetting> {
        return NSFetchRequest<CodingTestSetting>(entityName: "CodingTestSetting")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: String?
    @NSManaged public var timeLimit: Int32
    @NSManaged public var title: String?
    @NSManaged public var problems: NSSet?
    
    public var problemArr: [Problem] {
        let set = problems as? Set<Problem> ?? []
        
        return set.sorted {
            $0.difficulty < $1.difficulty
        }
    }
}

// MARK: Generated accessors for problems
extension CodingTestSetting {

    @objc(addProblemsObject:)
    @NSManaged public func addToProblems(_ value: Problem)

    @objc(removeProblemsObject:)
    @NSManaged public func removeFromProblems(_ value: Problem)

    @objc(addProblems:)
    @NSManaged public func addToProblems(_ values: NSSet)

    @objc(removeProblems:)
    @NSManaged public func removeFromProblems(_ values: NSSet)

}

extension CodingTestSetting : Identifiable {

}
