//
//  DefaultCoreDataService.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/13.
//

import CoreData
import Foundation

class DefaultCoreDataService: CoreDataService {
    static var shared: DefaultCoreDataService = DefaultCoreDataService()
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func addCodingTestSetting(_ title: String = "", _ timeLimit: Int = 3600) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "CodingTestSetting", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context) as! CodingTestSetting
            
            
            for _ in 0...(Int.random(in: 0...6)) {
                let codingTestID = UUID().uuidString
                
                managedObject.setValue(Date(), forKey: "date")
                managedObject.setValue(codingTestID, forKey: "id")
                managedObject.setValue(title, forKey: "title")
                managedObject.setValue(timeLimit, forKey: "timeLimit")
                
                let problem = Problem(context: self.context)
                problem.setValue(UUID().uuidString, forKey: "id")
                problem.setValue(Date(), forKey: "date")
                problem.setValue(false, forKey: "checkEfficiency")
                problem.setValue(false, forKey: "passAccuracyTest")
                problem.setValue(false, forKey: "passEfficiencyTest")
                problem.setValue(0, forKey: "accuracyTestPassTime")
                problem.setValue(0, forKey: "efficiencyTestPassTime")
                problem.setValue(Int.random(in: 1...5), forKey: "difficulty")
                
                problem.codingTest = managedObject
            }
            
            do {
                // try self.context.save()
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    func createProblem() -> Problem {
        let problem = Problem(context: self.context)
        problem.setValue(UUID().uuidString, forKey: "id")
        problem.setValue(Date(), forKey: "date")
        problem.setValue(false, forKey: "checkEfficiency")
        problem.setValue(false, forKey: "passAccuracyTest")
        problem.setValue(false, forKey: "passEfficiencyTest")
        problem.setValue(0, forKey: "accuracyTestPassTime")
        problem.setValue(0, forKey: "efficiencyTestPassTime")
        problem.setValue(Int.random(in: 1...5), forKey: "difficulty")
        
        return problem
    }
    
    func createCodingTesting(by codingTestSetting: CodingTestSetting) -> CodingTesting {        
        var problems: [Problem] = []
        
        for i in 0..<codingTestSetting.problemArr.count {
            let problem  = Problem(context: self.context)
            problem.setValue(UUID().uuidString, forKey: "id")
            problem.setValue(Date(), forKey: "date")
            problem.setValue(codingTestSetting.problemArr[i].checkEfficiency, forKey: "checkEfficiency")
            problem.setValue(false, forKey: "passAccuracyTest")
            problem.setValue(false, forKey: "passEfficiencyTest")
            problem.setValue(0, forKey: "accuracyTestPassTime")
            problem.setValue(0, forKey: "efficiencyTestPassTime")
            problem.setValue(codingTestSetting.problemArr[i].difficulty, forKey: "difficulty")
            
            problems.append(problem)
        }
        
        let codingTesting = CodingTesting(
            date: Date(),
            title: codingTestSetting.title ?? "",
            timeLimit: codingTestSetting.timeLimit,
            leftTime: codingTestSetting.timeLimit,
            problems: problems
        )
        
        return codingTesting
    }
    
    func createCodingTestResult(by codingTesting: CodingTesting) -> CodingTestResult? {
        
        let entity = NSEntityDescription.entity(forEntityName: "CodingTestResult", in: self.context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context) as! CodingTestResult
            
            managedObject.setValue(Date(), forKey: "date")
            managedObject.setValue(UUID().uuidString, forKey: "id")
            managedObject.setValue(codingTesting.title, forKey: "title")
            managedObject.setValue(codingTesting.timeLimit, forKey: "timeLimit")
            
            for i in 0..<codingTesting.problems.count {
                
                let problem = Problem(context: self.context)
                problem.setValue(UUID().uuidString, forKey: "id")
                problem.setValue(Date(), forKey: "date")
                problem.setValue(i, forKey: "index")
                problem.setValue(codingTesting.problems[i].checkEfficiency, forKey: "checkEfficiency")
                problem.setValue(codingTesting.problems[i].passAccuracyTest, forKey: "passAccuracyTest")
                problem.setValue(codingTesting.problems[i].passEfficiencyTest, forKey: "passEfficiencyTest")
                problem.setValue(codingTesting.problems[i].accuracyTestPassTime, forKey: "accuracyTestPassTime")
                problem.setValue(codingTesting.problems[i].efficiencyTestPassTime, forKey: "efficiencyTestPassTime")
                problem.setValue(codingTesting.problems[i].difficulty, forKey: "difficulty")
                
                problem.codingTestResult = managedObject
            }
            
            return managedObject
        } else {
            return nil
        }
    }
}
