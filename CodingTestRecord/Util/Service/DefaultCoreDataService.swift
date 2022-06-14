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
            let managedObject = NSManagedObject(entity: entity, insertInto: self.context)
            
            managedObject.setValue(UUID().uuidString, forKey: "id")
            managedObject.setValue(title, forKey: "title")
            managedObject.setValue(timeLimit, forKey: "timeLimit")
            
            do {
                // try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
}
