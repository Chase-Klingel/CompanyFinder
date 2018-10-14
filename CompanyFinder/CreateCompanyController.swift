//
//  CreateCompanyController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/7/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Protocols

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {
    
    //MARK: - Instance Variables
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            
            if let founded = company?.founded {
                datePicker.date = founded
            }
            
            if let companyImage = company?.companyImage {
                let image = UIImage(data: companyImage, scale: 0.8)
                companyImageView.image = image
            }
        }
    }
    
    let context =
        CoreDataManager.shared.persistentContainer.viewContext
    
    // MARK: - Delegate Assignment
    
    var delegate: CreateCompanyControllerDelegate?
    
    // MARK: - UI Elements
    
    let backgroundView: UIView = {
        let bv = UIView()
        bv.backgroundColor = .lightBlue
        
        return bv
    }()
    
    lazy var companyImageView: UIImageView = {
        let iv =
            UIImageView(image: #imageLiteral(resourceName: "select_photo_empty").withRenderingMode(.alwaysOriginal))
        let tapGesture =
            UITapGestureRecognizer(target: self,
                                   action: #selector(handlePresentPhotoSelector))
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tapGesture)
        iv.makeCirculor()
        
        return iv
    }()
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        
        return dp
    }()
    
    // MARK: - Present UIImagePickerController
    
    @objc func handlePresentPhotoSelector() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Select Photo/Dismiss UIImagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage =
            info[UIImagePickerControllerEditedImage] as? UIImage {
            
            companyImageView.image = editedImage
            
        } else if let originalImage =
            info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            companyImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Will Appear
    
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
    
    // MARK: - Dismiss Controller/Save Company Info
    
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
    
    // MARK: - Create/Update Company
    
    private func createCompany() {
        let company =
            NSEntityDescription.insertNewObject(forEntityName: "Company",
                                                into: context)
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 0.8)
            company.setValue(imageData, forKey: "companyImage")
        }
    
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
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            company?.companyImage = UIImageJPEGRepresentation(companyImage, 0.8)
        }
        
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
        anchorBackgroundView()
        anchorCompanyImageView()
        anchorNameLabelAndTextField()
        anchorDatePicker()
    }
    
    private func anchorBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor,
                              bottom: nil, trailing: view.trailingAnchor,
                              paddingTop: 0, paddingLeft: 0,
                              paddingBottom: 0, paddingRight: 0,
                              width: 0, height: 350)
    }
    
    private func anchorCompanyImageView() {
        view.addSubview(companyImageView)
        companyImageView.anchor(top: view.topAnchor, leading: nil,
                                bottom: nil, trailing: nil,
                                paddingTop: 8, paddingLeft: 0,
                                paddingBottom: 0, paddingRight: 0,
                                width: 100, height: 100)
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func anchorNameLabelAndTextField() {
        view.addSubview(nameLabel)
        nameLabel.anchor(top: companyImageView.bottomAnchor, leading: view.leadingAnchor,
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
    
    private func anchorDatePicker() {
        view.addSubview(datePicker)
        datePicker.anchor(top: nameLabel.bottomAnchor, leading: view.leadingAnchor,
                          bottom: backgroundView.bottomAnchor, trailing: view.trailingAnchor,
                          paddingTop: 0, paddingLeft: 0,
                          paddingBottom: 0, paddingRight: 0,
                          width: 0, height: 0)
    }
    
}
