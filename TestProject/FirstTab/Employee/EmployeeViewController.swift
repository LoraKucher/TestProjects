//
//  EmployeeViewController.swift
//  TestProject
//
//  Created by Lora Kucher on 30.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit
import CoreData

final class EmployeeViewController: UIViewController, EntityUser {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableview: UITableView!
    
    // MARK: - Private properties
    private var type: EmployeeType = .employee
    private var userObject = UserObject()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "employeeCell")
        tableview.tableFooterView = UIView()
    }
    
    // MARK: - Private methods
    @IBAction private func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: type = .employee
        case 1: type = .accountant
        case 2: type = .management
        default:
            break
        }
        tableview.reloadData()
    }
    
    @IBAction private func saveAction(_ sender: UIBarButtonItem) {
        type.save(newUser: createUser(with: type), and: userObject)
        do {
            try returnContext().save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
            navigationController?.popViewController(animated: true)
        } catch {
            preconditionFailure("Failed saving")
        }
    }
}

// MARK: - UITableView datasource methods
extension EmployeeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return type.rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as? EmployeeCell else {
            preconditionFailure("cell is nil")
        }
        cell.descriptionTextField.tag = indexPath.row
        cell.descriptionTextField.delegate = self
        
        cell.titleLabel.text = type.rows[indexPath.row]
        cell.descriptionTextField.placeholder = "Enter your \(type.rows[indexPath.row].lowercased())"
        return cell
    }
}

// MARK: - UITextfield delegate methods
extension EmployeeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let kActualText = (textField.text ?? "") + string
        switch textField.tag {
        case 0:
            userObject.name = kActualText
        case 1:
            userObject.salary = kActualText
        case 2:
            userObject.lunchTime = type == .management ? nil : kActualText
            userObject.receptionHours = type == .management ? kActualText : nil
        case 3:
            userObject.workplaceNumber = kActualText
        case 4:
            userObject.accountantType = kActualText
        default:
            print("Empty textfield")
        }
        return true
    }
}
