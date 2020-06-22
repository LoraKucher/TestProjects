//
//  EmployeeCell.swift
//  TestProject
//
//  Created by Lora Kucher on 30.10.2019.
//  Copyright © 2019 Lora Kucher. All rights reserved.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configCell(with indexPath: IndexPath, type: EmployeeType) {
        tag = indexPath.row
        titleLabel.text = type.rows[indexPath.row]
        descriptionTextField.placeholder = "Enter your \(type.rows[indexPath.row].lowercased())"
    }
}
