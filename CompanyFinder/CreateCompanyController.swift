//
//  CreateCompanyController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/7/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    //MARK: - Instance Variables
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
        }
    }
    
    // MARK: - Delegate Assignment
    
    var delegate: CreateCompanyControllerDelegate?
    
    // MARK: - UI Elements
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        
        return textField
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if company == nil {
            navigationItem.title = "Create Company"
        } else {
            navigationItem.title = "Edit Company"
        }
    }
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Cancel", style: .plain,
                            target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Save", style: .plain,
                            target: self, action: #selector(handleSave))
        setupUI()
    }
    
    // MARK: - Cancel and Save
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSave() {
        if company == nil {
            createCompany()
        } else {
            updateCompany()
        }
    }
    
    private func createCompany() {
        let context =
            CoreDataManager.shared.persistentContainer.viewContext
        
        let company =
            NSEntityDescription.insertNewObject(forEntityName: "Company",
                                                into: context)
        company.setValue(nameTextField.text, forKey: "name")
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let err {
            print("Failed to save new company: \(err)")
        }
    }
    
    private func updateCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        
        do {
            try context.save()
            dismiss(animated: true) {
               self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let err {
            print("Failed to update company name: \(err)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Position UI Elements
    
    private func setupUI() {
        addBackgroundView()
        addNameLabelAndTextField()
    }
    
    private func addBackgroundView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightBlue
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                              bottom: nil, trailing: view.trailingAnchor,
                              paddingTop: 0, paddingLeft: 0,
                              paddingBottom: 0, paddingRight: 0,
                              width: 0, height: 50)
    }
    
    private func addNameLabelAndTextField() {
        view.addSubview(nameLabel)
        nameLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                         bottom: nil, trailing: nil,
                         paddingTop: 0, paddingLeft: 16,
                         paddingBottom: 0, paddingRight: 0,
                         width: 100, height: 50)
        
        view.addSubview(nameTextField)
        nameTextField.anchor(top: nameLabel.topAnchor, leading: nameLabel.trailingAnchor,
                             bottom: nameLabel.bottomAnchor, trailing: view.trailingAnchor,
                             paddingTop: 0, paddingLeft: 0,
                             paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
    }
}
