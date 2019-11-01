//
//  ListViewController.swift
//  TestProject
//
//  Created by Lora Kucher on 29.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit
import CoreData

struct UserObject {
    var name: String?
    var salary: String?
    var lunchTime: String?
    var receptionHours: String?
    var workplaceNumber: String?
    var accountantType: String?
}

struct SectionData {
    let type: EmployeeType
    let data : [NSManagedObject]

    var numberOfItems: Int {
        return data.count
    }

    subscript(index: Int) -> NSManagedObject {
        return data[index]
    }
}

extension SectionData {
    
    init(type: EmployeeType, data: NSManagedObject...) {
        self.type = type
        self.data  = data
    }
}

final class ListViewController: UIViewController {
    
    // MARK: - Private IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private properties
    private lazy var model = ListModel()
    private var isEdit = false
    
    private lazy var mySections: [SectionData] = {
        let section1 = SectionData(type: .employee, data: sortedItems(by: .employee))
        let section2 = SectionData(type: .accountant, data: sortedItems(by: .accountant))
        let section3 = SectionData(type: .management, data: sortedItems(by: .management))

        return [section1, section2, section3]
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }
    
    // TODO: - observe changes!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.fetch { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @IBAction private func edit(_ sender: UIBarButtonItem) {
        isEdit = !isEdit
        tableView.setEditing(isEdit == true ? true : false, animated: true)
        sender.title = isEdit == true ? "Done" : "Edit"
    }
    
    // MARK: - Private methods
    private func sortedItems(by type: EmployeeType) -> [NSManagedObject] {
        return model.items
            .filter { $0.entity.name == type.stringValue.capitalized }
            .sorted {
                guard let firstName = $0.value(forKey: "name") as? String,
                    let secondName = $1.value(forKey: "name") as? String else {
                        return false
                }
                return firstName.localizedCaseInsensitiveCompare(secondName) == .orderedAscending
        }
    }
    
    // TODO: - send object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send object
    }
}

// MARK: - Tableview datasource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }
    
    // TODO: - remove titles if array is empty
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section].type.stringValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySections[section].data.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        model.delete(item: mySections[indexPath.section].data[indexPath.row])
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // TODO: - save index in model
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print(sourceIndexPath)
    }
    
    //TODO: - refactor
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let sourceSection = sourceIndexPath.section
        let destSection = proposedDestinationIndexPath.section
        
        if destSection < sourceSection {
            return IndexPath(row: 0, section: sourceSection)
        } else if destSection > sourceSection {
            return IndexPath(row: self.tableView(tableView, numberOfRowsInSection: sourceSection), section: sourceSection)
        }
        return proposedDestinationIndexPath
    }
    
    // TODO: - refactor
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListTableViewCell else {
            preconditionFailure("cell is nil")
        }
        switch indexPath.section {
        case 0:
            let factory = Factory(factory: EmployeeFactory())
            factory.addCell(in: cell, with: sortedItems(by: .employee), at: indexPath)
        case 1:
            let factory = Factory(factory: AccountantFactory())
            factory.addCell(in: cell, with: sortedItems(by: .accountant), at: indexPath)
        case 2:
            let factory = Factory(factory: ManagementFactory())
            factory.addCell(in: cell, with: sortedItems(by: .management), at: indexPath)
        default:
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEmployee", sender: nil)
    }
}
