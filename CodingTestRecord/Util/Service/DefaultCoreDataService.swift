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
}
