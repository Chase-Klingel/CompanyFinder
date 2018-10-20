//
//  CreateEmployee.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Protocols

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    //MARK: - Instance Variables

    var delegate: CreateEmployeeControllerDelegate?
    
    // MARK: - UI Elements

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
    
    // MARK: - View Did Load
    
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
    
    // MARK: - Save Employee
    
    @objc private func handleSave() {
        guard let emmployeeName = nameTextField.text else { return }
        let tuple =
            CoreDataManager.shared
                .saveEmployee(employeeName: emmployeeName)
        
        if let _ = tuple.1 {
            let errAlert: UIAlertController =
                errorAlert(title: "Failed to save Employee!",
                           message: """
                                    We apologize. Something went wrong
                                    while trying to save. Please try again.
                                    """)
            present(errAlert, animated: true, completion: nil)
        } else {
            dismiss(animated: true) {
                // force unwrapping ok b/c can guarantee a value
                
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
        }
    }
    
    // MARK: - Position UI Elements
    
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
