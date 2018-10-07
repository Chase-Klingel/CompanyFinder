//
//  CreateCompanyController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/7/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        navigationController?.title = "Create Company"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain,
                                                           target: self, action: #selector(handleCancel))
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        nameLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        nameLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
