//
//  EmployeesController+UITableView.swift
//  CompanyFinder
//
//  Created by Chase Klingel on 10/17/18.
//  Copyright © 2018 Chase Klingel. All rights reserved.
//

import UIKit

extension EmployeesController {
    
    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return employees[section].count
    }
    
    // MARK: - Did Select Row At
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                 for: indexPath)
        
        let employee = employees[indexPath.section][indexPath.row]
            
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white

        if let birthday = employee.employeeInfo?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            let birthdayStr = dateFormatter.string(from: birthday)
            cell.textLabel?.text = "\(employee.name ?? "") \(birthdayStr)"
        } else {
            cell.textLabel?.text = "\(employee.name ?? "")"
        }
            
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            
        return cell
    }
    
}
