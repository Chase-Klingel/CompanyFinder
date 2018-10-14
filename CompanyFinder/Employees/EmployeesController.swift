//
//  EmployeesController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class EmployeesController: UITableViewController {
    
    // MARK: - Instance Variables
    
    var company: Company?
    
    // MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkBlue
        setupPlusButtonInNavBar(selector: #selector(handleAddEmployee))
    }
    
    // MARK: - Add Employee
    
    @objc private func handleAddEmployee() {
        let creatEmployeeController = CreateEmployeeController()
        let navController =
            UINavigationController(rootViewController: creatEmployeeController)
        
        present(navController, animated: true, completion: nil)
    }
}
