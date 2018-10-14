//
//  EmployeesController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAddEmployee))
    }
    
    @objc private func handleAddEmployee() {
        print("hitting")
    }
}
