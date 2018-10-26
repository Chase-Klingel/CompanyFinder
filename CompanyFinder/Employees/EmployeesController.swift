//
//  EmployeesController.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/14/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController,
CreateEmployeeControllerDelegate {
    
    // MARK: - Instance Variables
    
    var company: Company?
    private(set) var employees = [[Employee]]()
    private(set) var cellId = "cellId"

    // MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        label.backgroundColor = .lightBlue
        
        /*
          Figure out how to not hard code section numbers.
          Base it off of how large employeeTypes is.
        */
        if section == 0 {
            label.text = CreateEmployeeController.employeeTypes[0]
        } else if section == 1 {
            label.text = CreateEmployeeController.employeeTypes[1]
        } else {
            label.text = CreateEmployeeController.employeeTypes[2]
        }
        
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        guard let company = company else { return }
        
        employees =
            CoreDataManager.shared.fetchEmployees(company: company)
            as! [[Employee]]
        
        setupPlusButtonInNavBar(selector: #selector(handleAddEmployee))
    }
    
    // MARK: - Add Employee
    
    @objc private func handleAddEmployee() {
        let creatEmployeeController = CreateEmployeeController()
        creatEmployeeController.delegate = self
        creatEmployeeController.company = company
        let navController =
            UINavigationController(rootViewController: creatEmployeeController)
        
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Delegate Methods
    
    func didAddEmployee(employee: Employee) {
        guard let employeeNameLength = employee.name?.count
            else { return }
        if employeeNameLength < 6 {
            employees[0].append(employee)
        } else {
            employees[1].append(employee)
        }

        tableView.reloadData()
    }
}
