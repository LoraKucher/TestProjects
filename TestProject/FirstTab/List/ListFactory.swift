//
//  ListFactory.swift
//  TestProject
//
//  Created by Lora Kucher on 01.11.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import Foundation
import CoreData

protocol CellFactory {
    func addCell(in cell: ListTableViewCell, with items: [NSManagedObject], at indexPath: IndexPath)
}

struct Factory {
    
    let factory: CellFactory
    
    func addCell(in cell: ListTableViewCell, with items: [NSManagedObject], at indexPath: IndexPath) {
        factory.addCell(in: cell, with: items, at: indexPath)
    }
}

struct EmployeeFactory: CellFactory {
    
    func addCell(in cell: ListTableViewCell, with items: [NSManagedObject], at indexPath: IndexPath) {
        cell.name.text = items[indexPath.row].value(forKey: "name") as? String
        cell.lunchTime.text = items[indexPath.row].value(forKey: "lunch_time") as? String
        cell.salary.text = items[indexPath.row].value(forKey: "salary") as? String
        cell.workplace.text = items[indexPath.row].value(forKey: "workplace_number") as? String
    }
}

struct AccountantFactory: CellFactory {
    
    func addCell(in cell: ListTableViewCell, with items: [NSManagedObject], at indexPath: IndexPath) {
        cell.name.text = items[indexPath.row].value(forKey: "name") as? String
        cell.lunchTime.text = items[indexPath.row].value(forKey: "lunch_time") as? String
        cell.salary.text = items[indexPath.row].value(forKey: "salary") as? String
        cell.workplace.text = items[indexPath.row].value(forKey: "workplace_number") as? String
        cell.uniqueType.text = items[indexPath.row].value(forKey: "accountant_type") as? String
    }
}

struct ManagementFactory: CellFactory {
    
    func addCell(in cell: ListTableViewCell, with items: [NSManagedObject], at indexPath: IndexPath) {
        cell.name.text = items[indexPath.row].value(forKey: "name") as? String
        cell.salary.text = items[indexPath.row].value(forKey: "salary") as? String
        cell.uniqueType.text = items[indexPath.row].value(forKey: "reception_hours") as? String
    }
}
