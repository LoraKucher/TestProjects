//
//  ListViewController.swift
//  TestProject
//
//  Created by Lora Kucher on 29.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit
import CoreData

protocol ReloadListViewContoller: class {
    func reload()
}

final class ListViewController: UIViewController {
    
    // MARK: - Private IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private properties
    private lazy var model = ListModel()
    private var isEdit = false
    
    private var mySections: [SectionData] {
        get {
            let section1 = SectionData(type: .employee, data: sortedItems(by: .employee), factory: EmployeeFactory())
            let section2 = SectionData(type: .accountant, data: sortedItems(by: .accountant), factory: AccountantFactory())
            let section3 = SectionData(type: .management, data: sortedItems(by: .management), factory: ManagementFactory())
            
            return [section1, section2, section3]
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        registerCell()
    }
    
    // MARK: - Actions
    @IBAction private func edit(_ sender: UIBarButtonItem) {
        isEdit = !isEdit
        tableView.setEditing(isEdit == true ? true : false, animated: true)
        sender.title = isEdit == true ? "Done" : "Edit"
    }
    
    // MARK: - Private methods
    private func registerCell() {
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }
    
    @objc private func getData() {
        model.fetch { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
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
        let segueDestination = segue.destination as? EmployeeViewController
        let object = sender as? NSManagedObject
        segueDestination?.object = object
        segueDestination?.delegate = self
        
    }
}

// MARK: - ReloadListViewContoller delegate
extension ListViewController: ReloadListViewContoller {
    func reload() {
        model.fetch { [weak self] in
            self?.tableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListTableViewCell else {
            preconditionFailure("cell is nil")
        }
        let data = mySections[indexPath.section].data
        let factory = mySections[indexPath.section].factory
        factory.addCell(in: cell, with: data, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let senderObject = mySections[indexPath.section].data[indexPath.row]
        performSegue(withIdentifier: "showEmployee", sender: senderObject)
    }
}
