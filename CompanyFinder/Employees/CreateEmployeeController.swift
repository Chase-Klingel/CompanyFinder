//
//  CreateEmployee.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class CreateEmployeeController: UIViewController {
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        
        return view
    }()
    
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
        
        anchorBackgroundView()
        anchorNameLabelAndTextField()
        anchorBirthLabelAndTextField()
    }
    
    @objc private func handleSave() {
        print("blah")
    }
    
    private func anchorBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                              bottom: nil, trailing: view.trailingAnchor,
                              paddingTop: 0, paddingLeft: 0,
                              paddingBottom: 0, paddingRight: 0,
                              width: 0, height: 350)
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
