//
//  EmployeeModel.swift
//  TestProject
//
//  Created by Lora Kucher on 01.11.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import Foundation
import CoreData

enum EmployeeType: CaseIterable, CodingKey, EntityUser {
    
    case employee
    case accountant
    case management
    
    var rows: [String] {
        let baseArray = ["Name", "Salary"]
        switch self {
        case .employee:
            return baseArray + ["Lunch time", "Workplace number"]
        case .accountant:
            return baseArray + ["Lunch time", "Workplace number", "Accountant type"]
        case .management:
            return baseArray + ["Reception hours"]
        }
    }
    
    func save(newUser: NSManagedObject, and object: UserObject) {
        newUser.setValue(object.name, forKey: "name")
        newUser.setValue(object.salary, forKey: "salary")
        switch self {
            case .employee:
                newUser.setValue(object.lunchTime, forKey: "lunch_time")
                newUser.setValue(object.workplaceNumber, forKey: "workplace_number")
            case .accountant:
                newUser.setValue(object.lunchTime, forKey: "lunch_time")
                newUser.setValue(object.workplaceNumber, forKey: "workplace_number")
                newUser.setValue(object.accountantType, forKey: "accountant_type")
            case .management:
                newUser.setValue(object.receptionHours, forKey: "reception_hours")
        }
    }
    
}
