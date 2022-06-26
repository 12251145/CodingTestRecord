//
//  TestCoreDataStack.swift
//  CodingTestRecordViewModelTests
//
//  Created by Hoen on 2022/06/26.
//


@testable import CodingTestRecord
import CoreData

class TestCoreDataStack {
    let persistentContainer: NSPersistentContainer
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: DefaultCoreDataService.modelName, managedObjectModel: DefaultCoreDataService.model)
        
        let description = NSPersistentStoreDescription()
        description.url = URL(filePath: "/dev/null")
        self.persistentContainer.persistentStoreDescriptions = [description]
        
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func createDummyCodingTestSetting() -> CodingTestSetting {
        let entity = NSEntityDescription.entity(forEntityName: "CodingTestSetting", in: self.persistentContainer.viewContext)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: self.persistentContainer.viewContext) as! CodingTestSetting

            let codingTestID = UUID().uuidString
            
            managedObject.setValue(Date(), forKey: "date")
            managedObject.setValue(codingTestID, forKey: "id")
            managedObject.setValue("테스트", forKey: "title")
            managedObject.setValue(10800, forKey: "timeLimit")
            
            return managedObject
        } else {
            return CodingTestSetting()
        }
    }
}
