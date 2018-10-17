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
                            numberOfRowsInSection section: Int)
        -> Int {
        
        return employees.count
    }
    
    // MARK: - Did Select Row At
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,
                                                 for: indexPath)
            
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = employees[indexPath.row].name
            
        return cell
    }
    
}
