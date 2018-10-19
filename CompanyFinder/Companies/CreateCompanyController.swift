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
    
    // MARK: - Delegate Assignment
    
    var delegate: CreateCompanyControllerDelegate?
    
    // MARK: - UI Elements
    
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
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
        
        setupCancelButton()
        setupSaveButtonInNavBar(selector: #selector(handleSave))

        setupUI()
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
        var imageData: Data?
        
        guard let companyName = nameTextField.text
            else { return }
        
        if let companyImage = companyImageView.image {
            imageData = UIImageJPEGRepresentation(companyImage, 0.8)
        }
        
        let tuple = CoreDataManager.shared
            .saveCompany(companyName: companyName,
                         companyFounded: datePicker.date,
                         companyImageData: imageData!)
        
        if let _ = tuple.1 {
            let errAlert =
                UIAlertController(title: "Failed to save company!",
                                  message: """
                                            We apologize. Something went wrong
                                            while trying to save. Please try again.
                                            """,
                                  preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            
            errAlert.addAction(defaultAction)
            
            present(errAlert, animated: true, completion: nil)
        } else {
            dismiss(animated: true) {
                // force unwrapping ok b/c can guarantee a value

                self.delegate?.didAddCompany(company: tuple.0!)
            }
        }
    }
    
    private func updateCompany() {
        company?.name = nameTextField.text
        company?.founded = datePicker.date

        if let companyImage = companyImageView.image {
            company?.companyImage =
                UIImageJPEGRepresentation(companyImage, 0.8)
        }
        
        let err = CoreDataManager.shared
            .saveCompanyUpdates()
        
        if let _ = err {
            let errAlert =
                UIAlertController(title: "Failed to update!",
                                  message: """
                                            We apologize. Something went wrong
                                            while trying to save. Please try again.
                                            """,
                                  preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .default) { (_) in
                self.dismiss(animated: true, completion: nil)
            }
            
            errAlert.addAction(defaultAction)
            
            present(errAlert, animated: true, completion: nil)
        } else {
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        }
    }
    
    // MARK: - Position UI Elements
    
    private func setupUI() {
        let backgroundView = anchorBackgroundView(height: 350)
        anchorCompanyImageView()
        anchorNameLabelAndTextField()
        anchorDatePicker(backgroundView: backgroundView)
    }

    
    private func anchorCompanyImageView() {
        view.addSubview(companyImageView)
        companyImageView.anchor(top: view.topAnchor, leading: nil,
                                bottom: nil, trailing: nil,
                                paddingTop: 8, paddingLeft: 0,
                                paddingBottom: 0, paddingRight: 0,
                                width: 100, height: 100)
        companyImageView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func anchorNameLabelAndTextField() {
        view.addSubview(nameLabel)
        nameLabel.anchor(top: companyImageView.bottomAnchor, leading: view.leadingAnchor,
                         bottom: nil, trailing: nil,
                         paddingTop: 0, paddingLeft: 16,
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
    
    private func anchorDatePicker(backgroundView: UIView) {
        view.addSubview(datePicker)
        datePicker.anchor(top: nameLabel.bottomAnchor, leading: view.leadingAnchor,
                          bottom: backgroundView.bottomAnchor, trailing: view.trailingAnchor,
                          paddingTop: 0, paddingLeft: 0,
                          paddingBottom: 0, paddingRight: 0,
                          width: 0, height: 0)
    }
    
}
