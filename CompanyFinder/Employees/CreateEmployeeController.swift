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
    var company: Company?

    // MARK: - UI Elements

    let nameLabel: UILabel =  {
        let label = IndentedLabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    let birthLabel: UILabel = {
        let label = IndentedLabel()
        label.text = "Birthday"
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
        textField.placeholder = "MM/dd/yyyy"
        
        return textField
    }()
    
    lazy var employeeTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: Constants.employeeTypes)
        sc.translatesAutoresizingMaskIntoConstraints  = false
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkBlue
        
        return sc
    }()
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue

        navigationItem.title = "Create Employee"
        setupCancelButton()
        setupSaveButtonInNavBar(selector: #selector(handleSave))
        
        // light grey background
        _ = anchorBackgroundView(height: 150)
        
        anchorNameLabelAndTextField()
        anchorBirthLabelAndTextField()
        anchorEmployeeTypeSegmentedControl()
    }
    
    // MARK: - Save Employee
    
    @objc private func handleSave() {        
        guard let company = company else { return }
        guard let emmployeeName = nameTextField.text else { return }
        guard let birthdayText = birthTextField.text else { return }
        
        if birthdayText.isEmpty {
            showAlert(title: "Empty Birthday",
                           message: "Please enter a birthday.")
            
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let birthdayDate = dateFormatter.date(from: birthdayText)
            else {
                showAlert(title: "Bad Date Format",
                      message: "Please type date as mm/dd/yyyy.")
                                
                return
        }
        
        guard let employeeType = employeeTypeSegmentedControl
            .titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex)
            else { return }
        
        let tuple =
            CoreDataManager.shared
                .createEmployee(employeeName: emmployeeName,
                                birthday: birthdayDate,
                                company: company,
                                employeeType: employeeType)
        
        if let _ = tuple.1 {
            showAlert(title: "Failed to save Employee!",
                      message: """
                                We apologize. Something went wrong
                                while trying to save. Please try again.
                               """)
            
            return
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
                         width: 100, height: 50)
        
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
                         width: 100, height: 50)
        
        view.addSubview(birthTextField)
        birthTextField.anchor(top: nil, leading: birthLabel.trailingAnchor,
                             bottom: nil, trailing: view.trailingAnchor,
                             paddingTop: 0, paddingLeft: 0,
                             paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
        birthTextField.centerYAnchor
            .constraint(equalTo: birthLabel.centerYAnchor).isActive = true
    }
    
    private func anchorEmployeeTypeSegmentedControl() {
        view.addSubview(employeeTypeSegmentedControl)
        employeeTypeSegmentedControl.anchor(top: birthLabel.bottomAnchor,
                                            leading: view.leadingAnchor, bottom: nil,
                                            trailing: view.trailingAnchor, paddingTop: 0,
                                            paddingLeft: 16, paddingBottom: 0, paddingRight: 16,
                                            width: 0, height: 0)
    }
}
