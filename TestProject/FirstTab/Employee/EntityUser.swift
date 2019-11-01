//
//  EntityUser.swift
//  TestProject
//
//  Created by Lora Kucher on 01.11.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit
import CoreData

protocol EntityUser {
    func createUser(with type: EmployeeType) -> NSManagedObject
    func returnContext() -> NSManagedObjectContext
}

extension EntityUser {
    func createUser(with type: EmployeeType) -> NSManagedObject {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:  type.stringValue.capitalized, in: context)
        return NSManagedObject(entity: entity!, insertInto: context)
    }
    
    func returnContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
