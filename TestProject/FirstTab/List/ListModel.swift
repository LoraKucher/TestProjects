//
//  ListModel.swift
//  TestProject
//
//  Created by Lora Kucher on 31.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit
import CoreData

typealias CompletionHandlerClosureType = () -> Void?

struct UserObject {
    var name: String?
    var salary: String?
    var lunchTime: String?
    var receptionHours: String?
    var workplaceNumber: String?
    var accountantType: String?
}

final class ListModel: EntityUser {

    var items: [NSManagedObject] = []
    private var completionHandler: CompletionHandlerClosureType?
    
    func fetch(completion: CompletionHandlerClosureType?) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Base_employee")
        request.returnsObjectsAsFaults = false

        do {
            guard let result = try returnContext().fetch(request) as? [NSManagedObject] else {
                preconditionFailure("Context is nil")
            }
            items = result
            completion?()
        } catch {
            preconditionFailure("Failure to fetch NSManagedObject request")
        }
    }
    
    func delete(item: NSManagedObject) {
        returnContext().delete(item)
        do {
            try returnContext().save()
        } catch {
            preconditionFailure("Failure to fsave")
        }
        fetch(completion: nil)
    }
    
}
