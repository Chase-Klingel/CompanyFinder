//
//  CreateEmployee.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import CoreData

class CreateEmployeeController: UIViewController {
    
    let nameLabel: UILabel =  {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    let birthLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"

        return textField
    }()
    
    let birthTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MM/DD/YYY"
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue

        navigationItem.title = "Create Employee"
        setupCancelButton()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        
        _ = anchorBackgroundView(height: 50)
        anchorNameLabelAndTextField()
        anchorBirthLabelAndTextField()
    }
    
    @objc private func handleSave() {
        guard let emmployeeName = nameTextField.text else { return }
        CoreDataManager.shared.createEmployee(employeeName: emmployeeName)
        
        dismiss(animated: true, completion: nil)
    }
    
    private func anchorNameLabelAndTextField() {
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                         bottom: nil, trailing: nil,
                         paddingTop: 0, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0,
                         width: 50, height: 50)
        
        view.addSubview(nameTextField)
        nameTextField.anchor(top: nil, leading: nameLabel.trailingAnchor,
                             bottom: nil, trailing: view.trailingAnchor,
                             paddingTop: 0, paddingLeft: 0,
                             paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
        nameTextField.centerYAnchor
            .constraint(equalTo: nameLabel.centerYAnchor).isActive = true
    }
    
    private func anchorBirthLabelAndTextField() {
        view.addSubview(birthLabel)
        birthLabel.anchor(top: nameLabel.bottomAnchor, leading: view.leadingAnchor,
                         bottom: nil, trailing: nil,
                         paddingTop: 0, paddingLeft: 0,
                         paddingBottom: 0, paddingRight: 0,
                         width: 50, height: 50)
        
        view.addSubview(birthTextField)
        birthTextField.anchor(top: nil, leading: birthLabel.trailingAnchor,
                             bottom: nil, trailing: view.trailingAnchor,
                             paddingTop: 0, paddingLeft: 0,
                             paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
        birthTextField.centerYAnchor
            .constraint(equalTo: birthLabel.centerYAnchor).isActive = true
    }
}
