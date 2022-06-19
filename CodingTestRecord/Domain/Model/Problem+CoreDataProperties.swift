//
//  Problem+CoreDataProperties.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/14.
//
//

import Foundation
import CoreData


extension Problem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Problem> {
        return NSFetchRequest<Problem>(entityName: "Problem")
    }

    @NSManaged public var accuracyTestPassTime: Int32
    @NSManaged public var checkEfficiency: Bool
    @NSManaged public var difficulty: Int32
    @NSManaged public var index: Int32
    @NSManaged public var efficiencyTestPassTime: Int32
    @NSManaged public var id: String?
    @NSManaged public var passAccuracyTest: Bool
    @NSManaged public var passEfficiencyTest: Bool
    @NSManaged public var date: Date
    @NSManaged public var codingTest: CodingTestSetting?
    @NSManaged public var codingTestResult: CodingTestResult?

}

extension Problem : Identifiable {

}
